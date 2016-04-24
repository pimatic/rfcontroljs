module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '1'
    '01': '0'
    '02': ''
  }
  # same for send
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'switch28'
    type: 'switch'
    values:
      unitCode:
        type: "number"
      state:
        type: "boolean"
    brands: ["Lidl 0655B"]
    pulseLengths: [350, 880, 10970]
    pulseCount: 66
    decodePulses: (pulses) ->
      # pulse looks like this: 101010101010101010101010101010100101010101010101011010100110011002
      # they all start with a prefix of 10101010101010101010101010101010010101010101010101
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # the binary result looks like this:
      # 1111111111111111000000000 | 1110 | 10    | 1
      # prefix                    | unit | state | postfix
      # after the prefix there is the 4 digit unit code, the state and inverse state and a final 1
      # the keys on the remote map to the unit code in the following way:
      # key '1' => 1110 which is a decimal 14
      # key '2' => 1011 which is a decimal 11
      # key '3' => 0111 which is a decimal 7
      # key '4' => 1101 which is a decimal 13
      # key 'master' => 0000 which is a decimal 0
      return result = {
        unitCode: helper.binaryToNumber(binary, 25, 28)
        state: helper.binaryToBoolean(binary, 29)
      }
    encodeMessage: (message) ->
      prefix = "10101010101010101010101010101010010101010101010101"
      unitCode = helper.map(helper.numberToBinary(message.unitCode, 4), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      inverseState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "" + prefix + unitCode + state + inverseState + "1002"
  }
