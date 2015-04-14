module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '01': '1' #binary 1
    '10': '0' #binary 0
    '02': ''  #footer
  }
  # same for send
  binaryToPulse = {
    '1': '01'
    '0': '10'
  }
  return protocolInfo = {
    name: 'switch11'
    type: 'switch'
    values:
      id:
        type: "binary"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["McPower"]
    pulseLengths: [ 566, 1267, 6992 ]
    pulseCount: 66
    decodePulses: (pulses) ->
      # pulses is something like: '12021212121212121212021212121212121212121203'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '1011111111011111111110'
      # now we extract the data from that string
      # | 1011111111|011111111|   1   |10
      # | ID?       |unit?    | State |Channel
      unit = helper.binaryToNumber(binary, 3, 3)
      if unit is 1
        state = helper.binaryToBoolean(binary, 4)
      else
        state = helper.binaryToBoolean(binary, 5)
      return result = {
        id: helper.binaryToNumber(binary, 6, 21)
        unit: unit
        state: state
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id,26), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      unit = helper.map(helper.numberToBinary(message.unit, 1), binaryToPulse)
      inv_state = !state
      if unit is 1
        return "011010#{unit}#{state}#{inv_state}#{id}02"
      else
        return "011010#{unit}#{inv_state}#{state}#{id}02"
  }
