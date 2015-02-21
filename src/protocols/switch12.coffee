module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '12': '1' #binary 1
    '02': '0' #binary 0
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '12'
    '0': '02'
  }
  return protocolInfo = {
    name: 'switch12'
    type: 'switch'
    values:
      id:
        type: "binary"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["Europe RS-200"]
    pulseLengths: [ 562, 1313, 3234, 52149 ]
    pulseCount: 44
    decodePulses: (pulses) ->
      # pulses is something like: '12021212121212121212021212121212121212121203'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '1011111111011111111110'
      # now we extract the data from that string
      # | 1011111111|011111111|   1   |10
      # | ID?       |unit?    | State |Channel
      return result = {
        id: helper.binaryToNumber(binary, 0, 9)
        unit: helper.binaryToNumber(binary, 20, 21)
        state: helper.binaryToBoolean(binary, 19)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 10), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      state_inv = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      unit2 = helper.map(helper.numberToBinary(message.unit, 2), binaryToPulse)
      unit1 = helper.map(helper.numberToBinary(message.unit+1, 2), binaryToPulse)
      return "#{id}#{state}1#{unit2}1#{state}11#{state_inv}#{state}#{unit2}03"
  }
