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
    name: 'switch3'
    type: 'switch'
    values:
      houseCode:
        type: "number"
      unitCode:
        type: "number"
      state:
        type: "boolean"
    brands: ["Brennenstuhl Comfort", "Elro Home Control"]
    pulseLengths: [306, 957, 9808]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010101011001100101010101100110011001100101011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '110011000010'
      # now we extract the temperature and humidity from that string
      # |     11001 |    10000 |              1 |    0 |
      # | HouseCode | UnitCode | inverted State | State|
      return result = {
        houseCode: helper.binaryToNumber(binary, 0, 4)
        unitCode: helper.binaryToNumber(binary, 5, 9)
        state: helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      houseCode = helper.map(helper.numberToBinary(message.houseCode, 5), binaryToPulse)
      unitCode = helper.map(helper.numberToBinary(message.unitCode, 5), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      inverseState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{houseCode}#{unitCode}#{inverseState}#{state}"
  }
