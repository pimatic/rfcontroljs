module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0101': '0' #binary 0
    '1010': '1' #binary 1
    '0110': '2' #binary tri-state
    '02': ''    #footer
  }
  binaryToPulse = {
    '2': '0110'
    '0': '0101'
    '1': '1010'
  }
  return protocolInfo = {
    name: 'switch16'
    type: 'switch'
    values:
      id:
        type: "char"
      unit:
        type: "number"
      state:
        type: "boolean"
    brands: ["Everflourish"]
    pulseLengths: [330, 1000, 10500]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01100101011001100110011001010110011001100110010102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '111100021112'
      # now we extract the data from the binary
      # | 2022 | 220  | 2222      | 0
      # | id   | unit | don´t care| state

      #now we extract the state.
      state = helper.binaryToBoolean(binary, 11)
      #first we save the tri-state as a char
      id = String.fromCharCode(64 + @binaryToNumber(binary, 0, 3))
      unit = @binaryToNumber(binary, 4, 6)
      return result = {
        id: id
        unit: unit
        state: state
      }
    encodeMessage: (message) ->
      unit = helper.map(helper.numberToBinary(message.unit, 3), {'1':'0101','0':'0110'})
      idCharNum = message.id.charCodeAt(0)-65
      if idCharNum > 3
        idCharNum = 3
      idParts = ['0110','0110','0110','0110']
      idParts[idCharNum] = '0101'
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      return "#{idParts[0]}#{idParts[1]}#{idParts[2]}#{idParts[3]}#{unit}0110011001100110#{state}02"

    binaryToNumber: (data, b, e) ->
      c = 1
      i = b
      while i < e
        if data[i] is '0'
          break
        i++
        c++
      return c
  }