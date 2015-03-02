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
    name: 'led3'
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
        when "00001110" then command = "white"
        when "00010000" then command = "red"
        when "00010001" then command = "green"
        when "00010010" then command = "blue"
        when "00010011" then command = "yellow"
        when "00010100" then command = "cyan"
        when "00010101" then command = "magenta"
        when "00001000" then command = "demo"
        when "00001100" then command = "bright+"
        when "00001111" then command = "bright-"
        when "00001101" then command = "color-"
        when "00001010" then command = "color+"
        when "00000101" then command = "mode+"
        when "00001011" then command = "mode-"
        when "00001001" then command = "speed+"
        when "00000111" then command = "speed-"
        else command = "code:#{commandcode}"
      return result= {
        id: helper.binaryToNumber(binary, 0, 15)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse)
      switch message.command
        when "on/off"  then commandcode = "00000001"
        when "white"   then commandcode = "00001110"
        when "red"     then commandcode = "00010000"
        when "green"   then commandcode = "00010001"
        when "blue"    then commandcode = "00010010"
        when "yellow"  then commandcode = "00010011"
        when "cyan"    then commandcode = "00010100"
        when "magenta" then commandcode = "00010101"
        when "demo"    then commandcode = "00001000"
        when "bright+" then commandcode = "00001100"
        when "bright-" then commandcode = "00001111"
        when "color-"  then commandcode = "00001101"
        when "color+"  then commandcode = "00001010"
        when "mode+"   then commandcode = "00000101"
        when "mode-"   then commandcode = "00001011"
        when "speed+"  then commandcode = "00001001"
        when "speed-"  then commandcode = "00000111"
        else #this gives the ability for personal commands
          if message.command[0..4] is "code:"
            commandcode = message.command[5..]
      commandcode = helper.map(commandcode, binaryToPulse)
      return "#{id}#{commandcode}02"
  }
