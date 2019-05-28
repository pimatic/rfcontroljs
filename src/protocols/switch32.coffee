module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0110': '0' #binary 0
    '0101': '1' #binary 1
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '0110'
    '1': '0101'
  }
  return protocolInfo = {
    name: 'switch32'
    type: 'switch'
    values:
      systemCode:
        enum: [0, 1, 2, 3, 4]
      programCode:
        enum: [0, 1, 2, 3, 4]
      state:
        type: "boolean"
    brands: ["Rising Sun RSL366", "Conrad RSL366", "PROmax"]
    pulseLengths: [440, 1300, 13488]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010110011001100101011001100110011001100110011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '110011000000'
      # now we extract the temperature and humidity from that string
      # |     1100   |    1100     | 000 | 0 |
      # | systemCode | programCode | -   | inverted state |
      return result = {
        systemCode: helper.binaryToBitPos(binary, 0, 3)
        programCode: helper.binaryToBitPos(binary, 4, 7)
        # LOW -> ON, HIGH -> OFF
        state: not helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      systemCode = helper.map(
        helper.bitPosToBinary(message.systemCode, 4), binaryToPulse)
      programCode = helper.map(
        helper.bitPosToBinary(message.programCode, 4), binaryToPulse)
      state = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{systemCode}#{programCode}011001100110#{state}02"
  }
