module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather19'
    type: 'weather'
    values:
      temperature:
        type: "number"
      id:
        type: "number"
      channel:
        type: "number"
    brands: ["Landmann BBQ Thermometer"]
    pulseLengths: [548, 1008, 1996, 3936]
    pulseCount: 66
    decodePulses: (pulses) ->
      # pulses is something like: '020202010101010101010101010101020101010102010201020101010201020203'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '11100000000000010000101010001011'
      # now we extract the temperature and humidity from that string
      # 1110 0000 0000 0001 0000 1010 1000 1011
      # IIII IICC TTTT TTTT TTTT TTTT xxxx xxxx
      # 0    4    8    12   16   20   24   28
      # I: Device ID, 6-bit unsigned Int
      # C: Channel (2 bits + 1, 00=1, 01=2, 10=3)
      # T: Temperature Value, 16-bit signed Int (divide decimal by 10)
      # x: Unused
      return result = {
        id: helper.binaryToNumber(binary, 0, 5)
        channel: helper.binaryToNumber(binary, 6, 7) + 1
        temperature: helper.binaryToSignedNumber(binary, 8, 23) / 10
      }
  }