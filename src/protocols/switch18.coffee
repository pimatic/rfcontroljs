module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '02': ''    #footer
    '01': '1' #binary 1
    '10': '0' #binary 0
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '01'
    '0': '10'
  }
  return protocolInfo = {
    name: 'switch18'
    type: 'switch'
    values:
      id:
        type: "binary"
      state:
        type: "boolean"
    brands: ["Otio", "Advisen"]
    pulseLengths: [600, 1200, 3500, 7000]
    pulseCount: 68
    decodePulses: (pulses) ->
      # pulses is something like: 10011001010110101010011001011010100101010110010101010101101001010203
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: ''01011100001011000111101111110011''
      # now we extract the temperature and humidity from that string
      # 01 | 01    | 0100011110100100010011010
      # 01 | state [ ID                        |
      return result = {
        id: helper.binaryToNumber(binary, 4, 31)
        state: helper.binaryToBoolean(binary, 2)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 28), binaryToPulse)
      state = (if message.state then '1001' else '0110')
      return "1001#{state}#{id}03"
  }