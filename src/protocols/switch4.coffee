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
    name: 'switch4'
    type: 'switch'
    values:
      unit:
        type: "number"
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["Cogex", "KlikAanKlikUit", "Intertechno", "Düwi Terminal"]
    pulseLengths: [306, 957, 9808]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010110010101100110011001100110010101100110011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '10100 00010 00'
      # now we extract the temperature and humidity from that string
      # |    10100 | 00010 |      0 |             0 |
      # |     Unit |    ID |  fixed | inverted state|
      return result = {
        unit: helper.binaryToNumber(binary, 0, 4)
        id: helper.binaryToNumber(binary, 5, 9)
        state: not helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      unit = helper.map(helper.numberToBinary(message.unit, 5), binaryToPulse)
      id = helper.map(helper.numberToBinary(message.id, 5), binaryToPulse)
      fixed = binaryToPulse['0']
      invertedState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{unit}#{id}#{fixed}#{invertedState}02"
  }
