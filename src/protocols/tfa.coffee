module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'tfa'
    type: 'weather'
    values:
      id:
        type: "number"
      temperature:
        type: "number"
      humidity:
        type: "number"
    models: ["tfa"]
    pulseLengths: [506, 625, 2013, 7728]
    pulseCount: 88
    decodePulses: (pulses) ->
      # pulses is something like: '01020102020201020101010101010102010101010202020101020202010102010101020103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      # | 01011101000000010 | 00011100111 | 00100010 |
      # | ?                 | Temp.       | Humid.   |
      return result = {
        id: 12,
        temperature: 23.6,
        humidity: 67
      }
  }
