module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather14'
    type: 'weather'
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
    brands: ["Prologue Temperature & Humidity Sensor"]
    pulseLengths: [480, 1960, 3908, 8784]
    pulseCount: 76
    decodePulses: (pulses) ->
      # pulses is something like: '0201010201020102010101010102020101010102010101010202020202020101020201010103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '11000111000000010010101011110011100100000'
      # now we extract the temperature and humidity from that string
      # 1100 0111 0000 0001 0010 1010 1111 0011 1001 0
      # xxxx IIII IIII CCxB TTTT TTTT TTTT HHHH HHHH xx
      # 0    4    8    12   16   20   24   28   32
      # I: Device ID, 8-bit unsigned Int
      # B: Low-Battery Flag (1-bit, 0=Battery OK, 1=Battery Low)
      # T: Temperature Value, 12-bit signed Int (divide decimal by 10)
      # H: Humidity, 8-bit unsigned Int, is always 11001100 if no humidity sensor is available
      # C: Channel (2 bits + 1, 00=1, 01=2, 10=3)
      # x: Unused
      result = {
        id: helper.binaryToNumber(binary, 4, 11)
        channel: helper.binaryToNumberLSBMSB(binary, 12, 13) + 1
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10
        lowBattery: not helper.binaryToBoolean(binary, 15)
      }
      humidity = helper.binaryToNumber(binary, 28, 35)
      unless humidity is 204
        result.humidity = humidity
      return result
  }
