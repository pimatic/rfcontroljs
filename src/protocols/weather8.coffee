module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather8'
    type: 'weather'
    values:
      temperature:
        type: "number"
      humidity:
        type: "number"
      id:
        type: "number"
    brands: []
    pulseLengths: [200, 1000, 2000, 8000]
    pulseCount: 74
    decodePulses: (pulses) ->
      # pulses is something like: '01010101020202010202020202020202020201010102010102020202010202020101020103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      #   0-----7   8-----15     16----23   24------------35
      # | 01010101 | 10001101 | 11000000  | 000100001001000
      # |   id     | battery ?|  Humid.   |  Signed temperature 
      return result = {
        id: helper.binaryToNumber(binary, 0, 7)
        temperature: helper.binaryToSignedNumber(binary, 24, 35)/10.0
        humidity: helper.binaryToNumber(binary, 16, 23)
      }
  }
