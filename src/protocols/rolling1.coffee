module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '10': '1' #binary 1
    '23': ''    #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'rolling1'
    type: 'switch'
    values:
      code:
        type: "string"
    brands: ["rollingCode"]
    pulseLengths: [500, 1000, 3000, 7250]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        code: binary
      }

    encodeMessage: (message) ->
      if message.state is true
        code = helper.map(message.codeOn[0], binaryToPulse)
      else
        code = helper.map(message.codeOff[0], binaryToPulse)

      return "#{code}23"
  }