module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '1' #binary 1
    '10': '0' #binary 0
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '10'
    '1': '01'
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
    brands: ["ADEO", "ELRO/Home Easy HE-852"]
    pulseLengths: [217, 648, 6696]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01101010011001100110011010101010101010101010101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumberLSBMSB(binary, 0, 11)
        unit: helper.binaryToNumberLSBMSB(binary, 12, 22)
        state: !helper.binaryToBoolean(binary, 23)
      }
    encodeMessage: (message) ->
      id  = helper.map(helper.numberToBinaryLSBMSB(message.id, 12), binaryToPulse)
      unit = helper.map(helper.numberToBinaryLSBMSB(message.unit, 11), binaryToPulse)
      state = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{id}#{unit}#{state}02"
  }