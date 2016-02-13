module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '32': ''  #header
    '01': '0' #binary 0
    '10': '1' #binary 1
    '03': ''  #footer1
    '13': ''  #footer2
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'shutter4'
    type: 'command'
    commands: ["up","down","stop"]
    values:
      id:
        type: "number"
      channel:
        type: "number"
      all: #channel 0 is all
        type: "boolean"
      command:
        type: "string"
    brands: ["ROHRMOTOR24"]
    pulseLengths: [ 352, 712, 1476, 5690 ]
    pulseCount: 82
    decodePulses: (pulses) ->
      # pulses for up, down and stop are something like:
      #32
      #0101011001010110010110010101010110010110101010010101100101
      #010101
      #01
      #010110010101
      #13 or 03

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '00010001001000001001111000100 000 0 001 000'
      # now we extract the data from that string
      # | 00010001001000001001111000100 | 001     | 0   | 001     | 000                      |
      # | id                            | channel | fix | command | command invers to footer |

      channel = helper.binaryToNumber(binary, 29, 31)
      all = (if channel = '0' then true else false)
      commandcode = binary[33..35]
      command = (
        switch commandcode
          when '001' then 'up'
          when '011' then 'down'
          when '101' then 'stop'
      )
      return result= {
        id: helper.binaryToNumber(binary, 0, 28)
        channel: channel
        all: all
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 29), binaryToPulse)
      if message.all
        channelcode = 0
        commandcode = (
          switch message.command
            when 'up' then '001000'
            when 'down' then '011001'
            when 'stop' then '101010'
        )
        footer = '13'
      else
        channelcode = message.channel
        switch message.command
          when 'up'
            commandcode = '001111'
            footer = '03'
          when 'down'
            commandcode = '011110'
            footer = '03'
          when 'stop'
            commandcode = '101010'
            footer = '13'

      channel = helper.map(helper.numberToBinary(channelcode, 3), binaryToPulse)
      command = helper.map(commandcode, binaryToPulse)

      return "32#{id}#{channel}01#{command}#{footer}"
  }
