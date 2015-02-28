module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather1'
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
    brands: []
    pulseLengths: [456, 1990, 3940, 9236]
    pulseCount: 74
    decodePulses: (pulses) ->
      # pulses is something like: '01020102020201020101010101010102010101010202020101020202010102010101020103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      #   0--3   4-----11  12-13  14-15   16--------27   28----35
      # | 0101 | 10001101 | 11  |   00  | 000100001001 | 00111101 |
      # | ?    |    ID    | BT  |Channel| Temp.        | Humid.   |
      lowBattery = not helper.binaryToBoolean(binary, 12)
      return result = {
        id: helper.binaryToNumber(binary, 4, 11)
        channel: helper.binaryToNumber(binary, 14, 15) + 1
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10
        humidity: helper.binaryToNumber(binary, 28, 35)
        lowBattery: lowBattery
      }
  }
