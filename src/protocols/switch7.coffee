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
      id:
        type: "number"
      systemcode:
        type: "number"
      state:
        type: "boolean"
    brands: ["eHome"]
    pulseLengths: [ 306, 307, 945, 947, 9720, 9752]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 4)
        systemcode: helper.binaryToNumber(binary, 5, 9)
        state: not helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 5), binaryToPulse)
      systemcode = helper.map(helper.numberToBinary(message.systemcode, 5), binaryToPulse)
      fixed = binaryToPulse['0']
      invertedState = (if message.state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{id}#{systemcode}#{fixed}#{invertedState}02"
  }
