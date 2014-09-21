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
    name: 'switch1'
    type: 'switch'
    values:
      id:
        type: "binary"
      all:
        type: "boolean"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["CoCo Technologies", "D-IO (Chacon)", "Intertechno", "KlikAanKlikUit", "Nexa"]
    pulseLengths: [268, 1282, 2632, 10168]
    pulseCount: 132
    decodePulses: (pulses) ->
      # pulses is something like: '020001000101000001000100010100010001000100000101000001
      # 000101000001000100010100000100010100010000010100000100010100000100010001000103'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '00100011110100100010011010010000'
      # now we extract the temperature and humidity from that string
      # | 00100011110100100010011010 |   0 |     1 | 0000 |
      # | ID                         | All | State | unit |
      return result = {
        id: helper.binaryToNumber(binary, 0, 25)
        all: helper.binaryToBoolean(binary, 26)
        state: helper.binaryToBoolean(binary, 27)
        unit: helper.binaryToNumber(binary, 28, 31)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse)
      all = (if message.all then binaryToPulse['1'] else binaryToPulse['0'])
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse)
      return "02#{id}#{all}#{state}#{unit}03"
  }
