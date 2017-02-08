module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0101': '1' #binary 1
    '1010': '2' #binary tri-state
    '0110': '0' #binary 0
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '0110'
    '1': '0101'
    '2': '1010'
  }
  return protocolInfo = {
    name: 'switch8'
    type: 'switch'
    values:
      systemcode:
        type: "number"
      programcode:
        type: "string"
      state:
        type: "boolean"
    brands: ["Rev"]
    pulseLengths: [189, 547, 5720]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010101010101010110011001101010010101010101101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '111100021112'
      # now we extract the data from the binary
      # | 11110      | 00211       | 1              | 2
      # | SystemCode | ProgramCode | inverse state  | state


      #first we save the tri-state as a char
      unit = @binaryToChar(binary, 5, 9)
      #now we extract the state.
      if binary[11] is '2' then state = true
      else state = false

      #for the rest we dont need the third state. Set all 2 to 0
      binary = helper.map(binary, {'2':'0','1':'1','0':'0'})
      #building the unit code to something like this 'E10'
      unit = ''+unit+helper.binaryToNumberMSBLSB(binary, 5, 9)

      return result = {
        systemcode: helper.binaryToNumberMSBLSB(binary, 0, 4)
        programcode: unit
        state: state
      }
    encodeMessage: (message) ->
      systemcode = helper.map(helper.numberToBinaryMSBLSB(message.systemcode, 5), binaryToPulse)
      unitChar = message.programcode.charCodeAt(0)-65
      unit2 = message.programcode.slice(1,message.programcode.length)
      unit = parseInt(unit2, 10)

      programcode1 = helper.numberToBinaryMSBLSB(unit, 5)
      programcode2 = programcode1.substr(0, 4-unitChar) + '2' + programcode1.substr(5-unitChar)
      programcode3 = helper.map(programcode2, binaryToPulse)

      inverseState = (if message.state then binaryToPulse['1'] else binaryToPulse['2'])
      state = (if message.state then binaryToPulse['2'] else binaryToPulse['1'])
      return "#{systemcode}#{programcode3}#{inverseState}#{state}02"

    binaryToChar: (data, b, e) ->
      c = 0
      i = e
      while i >= b
        if data[i] is '2'
          break
        i--
        c++
      return String.fromCharCode(65 + c)
  }