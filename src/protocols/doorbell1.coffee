module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0101': '1' #binary 1
    '1010': '1' #binary 1
    '0110': '0' #binary 0
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '0110'
    '1': '1010'
  }
  return protocolInfo = {
    name: 'doorbell1'
    type: 'switch'
    values:
      id:
        type: "number"
      unit:
        type: "number"
      state:
        type: "boolean"
    brands: ["ADEO"]
    pulseLengths: [217, 648, 6696]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumberLSBMSB(binary, 0, 4)
        unit: helper.binaryToNumberLSBMSB(binary, 5, 9)
        state: helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      id  = helper.map(helper.numberToBinaryLSBMSB(message.id, 5), binaryToPulse)
      unit = helper.map(helper.numberToBinaryLSBMSB(message.unit, 5), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      return "#{id}#{unit}1010#{state}02"
  }

