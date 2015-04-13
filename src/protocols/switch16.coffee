module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '01': ''    #header
    '02': '1' #binary 1
    '00': '0' #binary 0
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '02'
    '0': '00'
  }
  return protocolInfo = {
    name: 'switch16'
    type: 'switch'
    values:
      id:
        type: "number"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["CoCo Technologies", "D-IO (Chacon)", "Intertechno", "KlikAanKlikUit", "Nexa"]
    pulseLengths: [260, 2680, 1275, 10550]
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
        id: helper.binaryToNumber(binary, 56, 59)
        state: helper.binaryToBoolean(binary, 54)
        unit: helper.binaryToNumber(binary, 59, 63)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 4), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      reverseState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse)
      return "01020002000200000200020002020002000200020002000002020000020200020002000200020002000200020000020002020000020002#{state}#{reverseState}#{id}#{unit}03"
  }
