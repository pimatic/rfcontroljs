module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '01': '1' #binary 1
    '10': '0' #binary 0
    '12': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '01'
    '0': '10'
  }
  return protocolInfo = {
    name: 'switch9'
    type: 'switch'
    values:
      id:
        type: "number"
      state:
        type: "boolean"
      unit:
        type: "number"
    brands: ["DRU Heaters"]
    pulseLengths: [300, 600, 23000]
    pulseCount: 46
    decodePulses: (pulses) ->
      # pulses is something like: '01100110011010101001101010010101100112'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101010000100011101'
      # now we extract the data from that string
      # | 10101000|01000111| 0     |1
      # | ID?     |unit?   | State |?
      return result = {
        id: helper.binaryToNumber(binary, 0, 11)
        unit: helper.binaryToNumber(binary, 12, 19)
        state: helper.binaryToBoolean(binary, 20)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 12), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      unit = helper.map(helper.numberToBinary(message.unit, 8), binaryToPulse)
      return "#{id}#{unit}#{state}1012"
  }
