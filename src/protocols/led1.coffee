module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '02': ''
  }
  # same for send
  binaryToPulse = {
    '1': '01',
    '0': '10',
  }
  return protocolInfo = {
    name: 'led1'
    type: 'switch'
    values:
      id:
        type: "number"
      unit:
        type: "number"
      state:
        type: "boolean"
    brands: ["LED Stripe RF Dimmer (no name)"]
    pulseLengths: [348, 1051, 10864]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01011010010101100110011010101001010110010101100102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101000010101000001000010'
      # now we extract the data from that string
      # | 101000010101000001000 | 010  |
      # | ID                    | unit |
	   
      return result= {
        id: helper.binaryToNumber(binary, 0, 20)
        unit: helper.binaryToNumber(binary, 21, 23)
        state: true
      }

    encodeMessage: (message) ->
      if message.state is false then return "0"
      id = helper.map(helper.numberToBinary(message.id, 21), binaryToPulse)
      unit = helper.map(helper.numberToBinary(message.unit, 3), binaryToPulse)
      return "#{id}#{unit}02"
  }
