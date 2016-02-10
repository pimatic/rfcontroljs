module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '32': ''  #header
    '01': '0' #binary 0
    '10': '1' #binary 1
    '04': ''  #footer1
    '14': ''  #footer2
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'shutter3'
    type: 'command'
    commands: ["up","down","stop"]
    values:
      id:
        type: "number"
      channel:
        type: "number"
      command:
        type: "string"
    brands: ["Romotec"]
    pulseLengths: [366, 736, 1600, 5204, 10896 ]
    pulseCount: 82
    decodePulses: (pulses) ->
      # pulses for up, down and stop are something like:
      #32
      #0101101010100110011001010101010110100101100110101001011001
      #100101
      #01
      #010110010101
      #14 or 04

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '00111101010000001100101110010 001 0 001 000'
      # now we extract the data from that string
      # | 00111101010000001100101110010 | 001     | 0   | 001     | 000                      |
      # | id                            | channel | fix | command | command invers to footer |

      commandcode = binary[33..35]
      command = (
        switch commandcode
          when '001' then 'up'
          when '011' then 'down'
          when '101' then 'stop'
      )
      return result= {
        id: helper.binaryToNumber(binary, 0, 28)
        channel: helper.binaryToNumber(binary, 29, 31)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 29), binaryToPulse)
      channel = helper.map(helper.numberToBinary(message.channel, 3), binaryToPulse)
      commandcode = (
        switch message.command
          when 'up'  then '001000'
          when 'down' then '011001'
          when 'stop' then '101010'
      )
      command = helper.map(commandcode, binaryToPulse)

      return "32#{id}#{channel}01#{command}14"
  }
