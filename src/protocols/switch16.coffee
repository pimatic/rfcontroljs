module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '01': ''    #header
    '0200': '1' #binary 1
    '0002': '0' #binary 0
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '0200'
    '0': '0002'
  }
  return protocolInfo = {
    name: 'switch16'
    type: 'switch'
    values:
      id:
        type: "number"
	  all:
	    type: "boolean"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["Intertek 22541673 (z.B. Bauhaus)"]
    pulseLengths: [260, 2680, 1275, 10550]
    pulseCount: 132
    decodePulses: (pulses) ->
      # pulses is something like: '010200020002000002000200020200020002000200020000020200
	  # 000202000200020002000200020002000200000200020200000200020200020002000002020003'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '11100011111010111111110010011101'
      # now we extract the id, all, state and unit from that string
      # | 11100011111010111111110010 |   0 |     1 | 1101 |
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
      return "01#{id}#{all}#{state}#{unit}03"
  }
