module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0101': '1' #binary 1
    '0110': '0' #binary 0
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '0110'
    '1': '0101'
  }
  return protocolInfo = {
    name: 'switch18'
    type: 'switch'
    values:
      header:
        type: "number"
      unitCode:
        type: "number"
      state:
        type: "boolean"
    brands: ["MBO International Electronic GmbH"]
    pulseLengths: [132, 400, 4144]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01100110010101100110011001100110011001100110011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '001000000000'
      # now we extract header, unitCode, and switch state from that string
      # the state is inverted, i.e. ON is 0 and OFF is 1
      # | 001    | 0000       | 0              | 0        0 | 0              | 0    | 02
      # | header | unitCode   | inverted state | zero, zero | inverted state | zero | footer
      return result = {
        header: helper.binaryToNumberLSBMSB(binary, 0, 2),
        unitCode: helper.binaryToNumberLSBMSB(binary, 3, 6),
        state: not helper.binaryToBoolean(binary, 7)
      }
    encodeMessage: (message) ->
      header = helper.map(helper.numberToBinaryLSBMSB(message.header, 3), binaryToPulse)
      unitCode = helper.map(helper.numberToBinaryLSBMSB(message.unitCode, 4), binaryToPulse)
      inverseState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      zero = binaryToPulse['0']
      return "#{header}#{unitCode}#{inverseState}#{zero}#{zero}#{inverseState}#{zero}02"
  }