module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0110': '1' #binary 1
    '0101': '0' #binary 0
    '1010': '2' #binary 2
    '02': '' #footer
  }
  binaryToPulse = {
    '1': '0110'
    '0': '0101'
    '2': '1010'
  }
  return protocolInfo = {
    name: 'switch26'
    type: 'command'
    commands: ["on", "off"]
    values:
      channel:
        type: "string"
      unit:
        type: "string"
      command:
        type: "string"
    brands: ["Chacon EMW200TC"]
    pulseLengths: [480, 1476, 15260]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010110011001100110011001010110011001100110101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '011111011112'
      # now we extract the data from that string
      # |   011   | 1110 |   1111   |    2    |
      # | CHANNEL | UNIT | CONSTANT | command |
      channelCode = binary.slice(0,3)
      channel = (
        switch channelCode
          when '011' then 'A'
          when '101' then 'B'
          when '110' then 'C'
          else channelCode # could help someone
      )

      unitCode = binary.slice(3,7)
      unit = (
        switch unitCode
          when '0111' then '1'
          when '1011' then '2'
          when '1101' then '3'
          when '1110' then '4'
          else unitCode + binary.slice(7, 11) # could help someone
      )

      commandCode = binary[11]
      if commandCode == '2'
        command = "on"
      else
        command = "off"
      
      return result= {
        channel: channel
        unit: unit
        command: command
      }

    encodeMessage: (message) ->
      channelCode = (
        switch message.channel
          when 'A' then '011'
          when 'B' then '101'
          when 'C' then '110'
          else message.channel
      )

      unitCodeAndConstant = (
        switch message.unit
          when '1' then '01111111'
          when '2' then '10111111'
          when '3' then '11011111'
          when '4' then '11101111'
          else message.unit
      )
      
      if message.command == "on"
        commandCode = '2'
      else
        commandCode = '0'

      channelCode = helper.map(channelCode, binaryToPulse)
      unitCodeAndConstant = helper.map(unitCodeAndConstant, binaryToPulse)
      commandCode = helper.map(commandCode, binaryToPulse)
      return "#{channelCode}#{unitCodeAndConstant}#{commandCode}02"
  }
