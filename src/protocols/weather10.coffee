module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather10'
    type: 'weather'
    values:
      id:
        type: "number"
      channel:
        type: "number"
      temperature:
        type: "number"
    brands: ["Velleman WS8426S"]
    pulseLengths: [492, 969, 1948, 4004]
    pulseCount: 74
    decodePulses: (pulses) ->
      # pulses is something like: '01010102020202010201010101010101020202010201020102020202010101010101010103'
      # we first map: 01 => 0, 02 => 1, 03 => nothing
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '000111101000000011101010111100000000'
      # now we extract the temperature from that string
      # | 0100000110 | 01      | 000011110001 | 111100000000 |
      # | id         | channel | temp         | ?            |
      id = helper.binaryToNumber(binary, 0, 9)
      channel = helper.binaryToNumber(binary, 10, 11) + 1
      temperature = helper.binaryToSignedNumber(binary, 12, 23) / 10

      return result = {
        id: id
        channel: channel
        temperature: temperature
      }
  }
