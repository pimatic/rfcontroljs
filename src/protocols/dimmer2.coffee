module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '0001': 'N', # ON/OFF
    '0100': 'U', # DIM UP, don't turn on/off
    '0010': 'D', # DIM DOWN, don't turn on/off
    '002': ''
  }
  # same for send
  binaryToPulse = {
    '1': '01',
    '0': '10',
    'N': '0001',
    'U': '0100',
    'D': '0010'
  }
  return protocolInfo = {
    name: 'dimmer2'
    type: 'dimmer'
    values:
      id:
        type: "binary"
      dimlevel:
        type: "number"
        min: 0
        max: 15
    brands: ["LED Stripe RF Dimmer (no name)"]
    pulseLengths: [348, 1051, 10864]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01011010010101100110011010101001010110010101100102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '10100001010100000100001002'
      # now we extract the data from that string
      # | 1010000101010000010	     |   N  | 	 0  | # TODO
      # | 1010000101010000010	     |   U  | 	 0  | # TODO
      # | 1010000101010000010	     |   D  | 	 0  | # TODO
      # | ID                         | Type | State |
      switch
      	when binary[20] is "N" then #TODO How can I add this?
	when binary[20] is "U" then #TODO
	when binary[20] is "D" then #TODO
	else null
	   
      result = {
        id: helper.binaryToNumber(binary, 0, 19)
        dimlevel: helper.binaryToNumber(binary, 32, 35)
      }
      return result;

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
