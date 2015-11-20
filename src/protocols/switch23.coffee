module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '1' #binary 0
    '01': '0' #binary 1
    '02': ''  #footer
  }
  binaryToPulse = {
    '1': '10'
    '0': '01'
  }
  return protocolInfo = {
    name: 'switch23'
    type: 'switch'
    values:
      houseCode:
        type: "number"
      unitCode:
        type: "number"
      state:
        type: "boolean"
    brands: ["Power remote 1204380", "Steffen 1204380"]
    pulseLengths: [512, 1024, 6144]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '0110101001 0101011010 100110010110 10 0101 010101011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '01110 00011 101001 1 00 00001 0'
      # now we extract the HouseCode, the UnitCode and the State from that string
      # HouseCode is transmitted inverted!
      # |     10001 | 00011 | 101001 |     1 | 00 |    00001 |     02 |
      # | HouseCode | ????? | ?????? | State | ?? | UnitCode | Footer |
      return result = {
        houseCode: helper.binaryToNumberInverted(binary, 0, 4)
        unitCode: helper.binaryToNumber(binary, 19, 23)
        state: helper.binaryToBoolean(binary, 16)
      }
    encodeMessage: (message) ->
      houseCode = helper.map(helper.numberToBinaryInverted(message.houseCode, 5), binaryToPulse)
      unitCode = helper.map(helper.numberToBinary(message.unitCode, 5), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      return "#{houseCode}0101011010100110010110#{state}0101#{unitCode}02"
  }
