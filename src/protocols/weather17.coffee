module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '11': '0'
    '01': '1'
    '02': ''
    '12': ''
  }
  return protocolInfo = {
    name: 'weather17'
    type: 'weather'
    values:
      id:
        type: "number"
      channel:
        type: "number"
      temperature:
        type: "number"
      humidity:
        type: "number"
    brands: ["TFA 30.3125"]
    pulseLengths: [444, 1160, 28580]
    pulseCount: 88
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)

      # tens place of temperature/humidity value (5 to be subtracted from temperature)
      p0 = helper.binaryToNumber(binary, 20, 23)
      # ones place of temperature/humidity value
      p1 = helper.binaryToNumber(binary, 24, 27)
      # decimal fraction of temperature/humidity value
      p2 = helper.binaryToNumber(binary, 28, 31)

      # id will change if battery is replaced
      result =
        id: helper.binaryToNumber(binary, 12, 18)
        channel: helper.binaryToNumber(binary, 8, 10)

      # depending on the channel value, either temperature or humidity has been received
      # 000 = temperature, 111 = Humidity
      if result.channel is 0
        result.temperature = ((p0 - 5) * 10) + p1 + (p2 * 0.1)
      else
        result.humidity = p0 * 10 + p1
      return result
  }