module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '02': ''    #header
    '0100': '1' #binary 1
    '0001': '0' #binary 0
    '0000': 'N' #state = don't change
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '0100'
    '0': '0001'
    'N': '0000'
  }
  return protocolInfo = {
    name: 'dimmer1'
    type: 'dimmer'
    values:
      id:
        type: "binary"
      all:
        type: "boolean"
      state:
        type: "boolean"
      unit:
        type: "number"
      dimlevel:
        type: "number"
        min: 0
        max: 15
    brands: ["CoCo Technologies", "D-IO (Chacon)", "Intertechno", "KlikAanKlikUit", "Nexa"]
    pulseLengths: [260, 1300, 2700, 10400]
    pulseCount: 148
    decodePulses: (pulses) ->
      # pulses is something like: '0200010001010000010001010000010001000101000100010001000100
      # 000101000100010000010001000100010001010001000001000100000001000100010001010001000100010013'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '001000111101001000100110100100000001'
      # now we extract the data from that string
      #   00100100011111011100000110     0       N   0000    1111
      # | 00100011110100100010011010 |   0 |     1 | 0000 |  0001 |
      # | ID                         | All | State | unit | level |
      if binary[27] isnt "N"
        state = helper.binaryToBoolean(binary, 27)

      result = {
        id: helper.binaryToNumber(binary, 0, 25)
        all: helper.binaryToBoolean(binary, 26)
        unit: helper.binaryToNumber(binary, 28, 31)
        dimlevel: helper.binaryToNumber(binary, 32, 35)
        state: state
      }
      return result

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse)
      all = (if message.all then binaryToPulse['1'] else binaryToPulse['0'])
      if message.state?
        state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      else
        state = binaryToPulse['N']
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse)
      dimlevel = helper.map(helper.numberToBinary(message.dimlevel, 4), binaryToPulse)
      return "02#{id}#{all}#{state}#{unit}#{dimlevel}03"
  }
