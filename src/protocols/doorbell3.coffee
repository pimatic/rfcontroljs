module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0'
    '10': '1'
    '2': ''
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'doorbell3'
    type: 'switch'
    values:
      id:
        type: "number"
      unit:
        type: "number"
    brands: ["WP515S"]
    pulseLengths: [300, 580, 10224]
    pulseCount: 26
    decodePulses: (pulses) ->
      src = pulses.substring(1)
      binary = helper.map(src, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 3),
        unit: helper.binaryToNumber(binary, 4, 11),
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 4), binaryToPulse)
      unit = helper.map(helper.numberToBinary(message.unit, 8), binaryToPulse)
      return "0#{id}#{unit}2"
  }

