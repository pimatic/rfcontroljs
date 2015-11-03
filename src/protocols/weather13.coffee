module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather13'
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
    brands: ["Xiron Temperature & Humidity Sensor 2"]
    pulseLengths: [492, 992, 2028, 4012]
    pulseCount: 74
    decodePulses: (pulses) ->
      # pulses is something like: '02020202010101020201020101010101020202010202010202020202010102020101010103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '11000111000000010010101011110011100100000'
      # now we extract the temperature and humidity from that string
      # 1100 0111 0000 0001 0010 1010 1111 0011 1001 0
      # IIII IIII BxCC TTTT TTTT TTTT xxxx HHHH HHHH x
      # 0    4    8    12   16   20   24   28   32
      # I: Device ID, 8-bit unsigned Int
      # B: Low-Battery Flag (1-bit, 0=Battery OK, 1=Battery Low)
      # T: Temperature Value, 12-bit signed Int (divide decimal by 10)
      # H: Humidity, 8-bit unsigned Int
      # C: Channel (2 bits + 1, 00=1, 01=2, 10=3)
      # x: Unused
      lowBattery = not helper.binaryToBoolean(binary, 8)
      return result = {
        id: helper.binaryToNumber(binary, 0, 7)
        channel: helper.binaryToNumber(binary, 10, 11) + 1
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10
        humidity: helper.binaryToNumber(binary, 28, 35)
        lowBattery: lowBattery
      }
  }
