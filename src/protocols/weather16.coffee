module.exports = (helper) ->
  pulsesToBinaryMapping =
    '01': "0"
    '02': "1"
    '03': ""
  return protocolInfo = {
    name: "weather16"
    type: "weather"
    values:
      temperature:
        type: "number"
      humidity:
        type: "number"
      channel:
        type: "number"
      id:
        type: "number"
      lowBattery:
        type: "boolean"
    brands: ["Ea2 labs Bl999"]
    pulseLengths: [500, 1850, 3900, 9000]
    pulseCount: 74
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumberLSBMSB(binary, 0, 7)
        channel: helper.binaryToNumber(binary, 4, 5)
        temperature: helper.binaryToSignedNumberLSBMSB(binary, 12, 23) / 10.0
        humidity: helper.binaryToSignedNumberLSBMSB(binary, 24, 31) + 100
        lowBattery: helper.binaryToNumberLSBMSB(binary, 8, 8) isnt 0
      }
  }
