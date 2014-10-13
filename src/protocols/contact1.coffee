module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '02': ''    #header
    '0100': '1' #binary 1
    '0001': '0' #binary 0
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '0100'
    '0': '0001'
  }
  return protocolInfo = {
    name: 'contact1'
    type: 'contact'
    values:
      id:
        type: "binary"
      all:
        type: "boolean"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["KlikAanKlikUit"]
    pulseLengths: [268, 1282, 2632, 10168]
    pulseCounts: [132, 148]
    decodePulses: (pulses) ->
      # pulses is something like: '020001000101000100000100010001010001000001010001000100010001000
      # 0010100000100010001010001000001010001000001000101000100000100010100000101000001000103
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '001100011011111010001101100110010100'
      # now we extract the temperature and humidity from that string
      # | 00110001101111101000110110 |   0 |     1 | 1001 | [0100]
      # | ID                         | All | State | unit | ?
      return result = {
        id: helper.binaryToNumber(binary, 0, 25)
        all: helper.binaryToBoolean(binary, 26)
        state: helper.binaryToBoolean(binary, 27)
        unit: helper.binaryToNumber(binary, 28, 31)
      }
  }
