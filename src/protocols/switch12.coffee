module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '12': '1' #binary 1
    '02': '0' #binary 0
    '13': ''
    '03': ''  #footer
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
    pulseLengths: [ 562, 1313, 3234, 34888 ]
    pulseCount: 52
    decodePulses: (pulses) ->
      # pulses is something like: '12021212121212121212021212121212121212121203'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '1011111111011111111110'
      # now we extract the data from that string
      # | 1011111111|011111111|   1   |10
      # | ID?       |unit?    | State |Channel
      return result = {
        id: helper.binaryToNumber(binary, 0, 13)
        unit: helper.binaryToNumber(binary, 16, 17)
        state: helper.binaryToBoolean(binary, 19)
      }
    encodeMessage: (message) ->
      id = helper.numberToBinary(message.id, 14)
      state = (if message.state then '1' else '0')
      state_inv = (if message.state then '0' else '1')
      unit1 = helper.numberToBinary(message.unit, 2)
      rfstring = helper.map("#{id}#{state}1#{unit1}1#{state}11#{state_inv}#{state}0", binaryToPulse)
      return "#{rfstring}03"
  }
