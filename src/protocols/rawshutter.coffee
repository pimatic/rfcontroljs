module.exports = (helper) ->
  return protocolInfo = {
    name: 'rawshutter'
    type: 'command'
    commands: ["up","down","stop"]
    values:
      pulseCount:
        type: "number"
      pulseLengths:
        type: "object"
      pulsesUp:
        type: "string"
      pulsesDown:
        type: "string"
      pulsesStop:
        type: "string"
    brands: ["RAW"]
    pulseLengths: []
    pulseCount: 0
    decodePulses: (pulses) ->
      # Currently only encodeMessage is supported
      return null
    encodeMessage: (message) ->
      this.pulseLengths =  message.pulseLengths
      pulses = (
        switch message.command
          when undefined then ''
          when 'up'  then message.pulsesUp
          when 'down' then message.pulsesDown
          when 'stop' then message.pulsesStop
      )
      return pulses
  }
