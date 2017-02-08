module.exports = (helper) ->
  return protocolInfo = {
    name: 'rawswitch'
    type: 'switch'
    values:
      pulseCount:
        type: "number"
      pulseLengths:
        type: "object"
      pulsesOn:
        type: "string"
      pulsesOff:
        type: "string"
    brands: ["RAW"]
    pulseLengths: []
    pulseCount: 0
    decodePulses: (pulses) ->
      # Currently only encodeMessage is supported
      return null
    encodeMessage: (message) ->
      this.pulseLengths =  message.pulseLengths
      pulses = (if message.state then message.pulsesOn else message.pulsesOff )
      return pulses
  }
