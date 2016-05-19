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
    name: 'switch27'
    type: 'switch'
    values:
      channel:
        type: "string"
      unit:
        type: "string"
      state:
        type: "boolean"
    brands: ["Chacon Zen (EMW200TB)"]
    pulseLengths: [325, 972, 10130]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01100110011001100101011001100110011001100110101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '011111011112'
      # now we extract the data from that string
      # |  1111   | 01111 |    11    |    2    |
      # | CHANNEL |  UNIT | CONSTANT | command |
      channelCode = binary.slice(0,4)
      channel = (
        switch channelCode
          when '1111' then 'A'
          when '1011' then 'B'
          when '1101' then 'C'
          when '1110' then 'D'
          else channelCode # could help someone
      )

      unitCode = binary.slice(4,9)
      unit = (
        switch unitCode
          when '01111' then '1'
          when '10111' then '2'
          when '11011' then '3'
          else unitCode + binary.slice(9, 11) # could help someone
      )

      state = binary[11] == '2'
    
      return result= {
        channel: channel
        unit: unit
        state: state
      }

    encodeMessage: (message) ->
      channelCode = (
        switch message.channel
          when 'A' then '1111'
          when 'B' then '1011'
          when 'C' then '1101'
          when 'D' then '1110'
          else message.channel
      )

      unitCodeAndConstant = (
        switch message.unit
          when '1' then '0111111'
          when '2' then '1011111'
          when '3' then '1101111'
          else message.unit
      )
      
      if message.state
        commandCode = '2'
      else
        commandCode = '0'

      channelCode = helper.map(channelCode, binaryToPulse)
      unitCodeAndConstant = helper.map(unitCodeAndConstant, binaryToPulse)
      commandCode = helper.map(commandCode, binaryToPulse)
      return "#{channelCode}#{unitCodeAndConstant}#{commandCode}02"
  }
