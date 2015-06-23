module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '02': '0' #binary 0
    '21': '1' #binary 1
    '03': ''  #footer1
  }
  binaryToPulse = {
    '0': '02'
    '1': '21'
  }
  return protocolInfo = {
    name: 'shutter5'
    type: 'command'
    values:
      id:
        type: "number"
      channel:
        type: "number"
    brands: ["eSmart"]
    pulseLengths: [ 160, 270, 665, 6856 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses for up, down and stop are something like:
      #0221020202210202212102210221212102022121
      #022102
      #0203

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '01000100110101110011 010 0'
      # now we extract the data from that string
      # | 01000100110101110011 | 010     | 0 |
      # | id                   | command | ? |
  
      commandcode = binary[20..22]
      command = (
        switch commandcode
          when '001' then 'up'
          when '010' then 'down'
          when '100' then 'stop'
      )
      return result= {
        id: helper.binaryToNumber(binary, 0, 19)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 20), binaryToPulse)
      commandcode = (
        switch message.command
          when 'up'  then '001'
          when 'down' then '010'
          when 'stop' then '100'
      )
      command = helper.map(commandcode, binaryToPulse)

      return "#{id}#{command}0203"
  }
