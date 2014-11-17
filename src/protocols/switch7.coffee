module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '0' #binary 0
    '01': '1' #binary 1
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '10'
    '1': '01'
  }
  return protocolInfo = {
    name: 'switch7'
    type: 'switch'
    values:
      unit:
        type: "number"
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["eHome"]
    pulseLengths: [307, 944, 9712]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        unit: helper.binaryToNumber(binary, 1, 6)
        id: helper.binaryToNumber(binary, 7, 13)
        state: helper.binaryToBoolean(binary, 0)
      }
    encodeMessage: (message) ->
      unit = helper.map(helper.numberToBinary(message.unit, 5), binaryToPulse)
      id = helper.map(helper.numberToBinary(message.id, 5), binaryToPulse)
      fixed = binaryToPulse['0']
      invertedState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{unit}#{id}#{fixed}#{invertedState}02"
  }
