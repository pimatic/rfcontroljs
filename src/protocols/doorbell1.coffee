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
  binaryToPulse2 = {
    '0': '0110'
    '1': '0101'
  }
  return protocolInfo = {
    name: 'doorbell1'
    type: 'switch'
    values:
      systemcode:
        type: "number"
      programcode:
        type: "number"
      state:
        type: "boolean"
    brands: ["ADEO"]
    pulseLengths: [217, 648, 6696]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        systemcode: helper.binaryToNumberLSBMSB(binary, 0, 4)
        programcode: helper.binaryToNumberLSBMSB(binary, 5, 9)
        state: helper.binaryToBoolean(binary, 11)
      }
    encodeMessage: (message) ->
      systemcode  = helper.map(helper.numberToBinaryLSBMSB(message.systemcode, 5), binaryToPulse)
      programcode = helper.map(helper.numberToBinaryLSBMSB(message.programcode, 5), binaryToPulse)
      state = (if message.state then binaryToPulse['1'] else binaryToPulse['0'])
      return "#{systemcode}#{programcode}1010#{state}02"
  }
