module.exports = (helper) ->
  return protocolInfo = {
    name: 'switch25'
    type: 'command'
    commands: ["on", "off", "both"]
    values:
      id:
        type: "number"
      unit:
        type: "number"
      command:
        type: "string"
    brands: ["oh!haus & Co."]
    pulseLengths: [417, 1287, 13042]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010110010101100101011001100110011001010101101002'
      # no good mapping was found that satisfied all codes
      # | 0101011001010110010101100 | 110011001100101 | 01011010 | 02
      # | ID                        |       unit      |  command | header
      commandcode = pulses[40..47]
      switch commandcode
        when "01011010" then command = "on"
        when "10100101" then command = "off"
        when "01010101" then command = "both"
      return result= {
        id: helper.binaryToNumber(pulses, 0, 24)
        unit: helper.binaryToNumber(pulses, 25, 39)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.numberToBinary(message.id, 25)
      unit = helper.numberToBinary(message.unit, 15)
      switch message.command
        when "on" then commandcode = "01011010"
        when "off" then commandcode = "10100101"
        when "both" then commandcode = "01010101"
      return "#{id}#{unit}#{commandcode}02"
  }
