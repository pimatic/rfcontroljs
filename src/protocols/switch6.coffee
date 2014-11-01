module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0101': '1' #binary 1
    '1010': '1' #binary 1
    '0110': '0' #binary 0
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '0110'
    '1': '1010'
  }
  binaryToPulse2 = {
    '0': '0110'
    '1': '0101'
  }
  return protocolInfo = {
    name: 'switch6'
    type: 'switch'
    values:
      systemcode:
        type: "number"
      programcode:
        type: "number"
      state:
        type: "boolean"
    brands: ["Impuls"]
    pulseLengths: [150, 453, 4733]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '10010101101010010110010110101001010101011010101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '011100011011000111110000'
      # now we extract the temperature and humidity from that string
      # | 01110      | 01000       | 0              | 1
      # | SystemCode | ProgramCode | invertes state | state
      return result = {
        systemcode: helper.binaryToNumberLSBMSB(binary, 0, 4)
        programcode: helper.binaryToNumberLSBMSB(binary, 5, 9)
        state: helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      systemcode = helper.map(helper.numberToBinaryLSBMSB(message.systemcode, 5), binaryToPulse)
      programcode = helper.map(helper.numberToBinaryLSBMSB(message.programcode, 5), binaryToPulse2)
      inverseState = (if message.state then binaryToPulse2['0'] else binaryToPulse2['1'])
      state = (if message.state then binaryToPulse2['1'] else binaryToPulse2['0'])
      return "#{systemcode}#{programcode}#{inverseState}#{state}02"
  }