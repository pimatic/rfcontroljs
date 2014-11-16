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
    name: 'switch7'
    type: 'switch'
    values:
      unit:
        type: "number"
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["eHome"]
    pulseLengths: [ 306, 307, 945, 947, 9720, 9752]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
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
