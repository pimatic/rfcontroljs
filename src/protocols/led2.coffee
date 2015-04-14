module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '02': ''
  }
  # same for send
  binaryToPulse = {
    '0': '01',
    '1': '10',
  }
  return protocolInfo = {
    name: 'led2'
    type: 'command'
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["LED Controller"]
    pulseLengths: [ 439, 1240, 12944 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01011010011010100110010110010101010101010101011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101000010101000001000010'
      # now we extract the data from that string
      # | 101000010101000001000 |   010   |
      # | ID                    | command |
      commandcode = binary[16..23]
      switch commandcode
        when "00000001" then command = "on/off"
        when "00000100" then command = "light"
        when "00000101" then command = "bright+"
        when "00000110" then command = "bright-"
        when "00000111" then command = "100%"
        when "00001000" then command = "50%"
        when "00001001" then command = "25%"
        when "00001011" then command = "mode+"
        when "00010001" then command = "mode-"
        when "00001111" then command = "speed+"
        when "00001101" then command = "speed-"
        else command = "code:#{commandcode}"
      return result= {
        id: helper.binaryToNumber(binary, 0, 15)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse)
      switch message.command
        when "on/off"  then commandcode = "00000001"
        when "light"   then commandcode = "00000100"
        when "bright+" then commandcode = "00000101"
        when "bright-" then commandcode = "00000110"
        when "100%"    then commandcode = "00000111"
        when "50%"     then commandcode = "00001000"
        when "25%"     then commandcode = "00001001"
        when "mode+"   then commandcode = "00001011"
        when "mode-"   then commandcode = "00010001"
        when "speed+"  then commandcode = "00001111"
        when "speed-"  then commandcode = "00001101"
        else #this gives the ability for personal commands
          if message.command[0..4] is "code:"
            commandcode = message.command[5..]
      commandcode = helper.map(commandcode, binaryToPulse)
      return "#{id}#{commandcode}02"
  }
