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
    brands: []
    pulseLengths: [456, 1990, 3940, 9236]
    pulseCount: 74
    decodePulses: (pulses) ->
      # pulses is something like: '01020102020201020101010101010102010101010202020101020202010102010101020103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      # | 01011101000000010 | 00011100111 | 00100010 |
      # | ?                 | Temp.       | Humid.   |
      return result = {
        temperature: helper.binaryToNumber(binary, 18, 27) / 10
        humidity: helper.binaryToNumber(binary, 28, 35)
      }
  }
