module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '11': '1',
    '02': ''
  }
  # same for send
  binaryToPulse = {
    '0': '01',
    '1': '10',
  }
  return protocolInfo = {
    name: 'led4'
    type: 'command'
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["LED Controller"]
    pulseLengths: [ 345, 967, 9484 ]
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
        when "10000101" then command = "on/off"
        when "10000011" then command = "bright+"
        when "10000010" then command = "bright-"
        when "10000111" then command = "color-"
        when "10000110" then command = "color+"
        else command = "code:#{commandcode}"
      return result= {
        id: helper.binaryToNumber(binary, 0, 15)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse)
      switch message.command
        when "on/off"  then commandcode = "10000101"
        when "bright+" then commandcode = "10000011"
        when "bright-" then commandcode = "10000010"
        when "color-"  then commandcode = "10000111"
        when "color+"  then commandcode = "10000110"
        else #this gives the ability for personal commands
          if message.command[0..4] is "code:"
            commandcode = message.command[5..]
      commandcode = helper.map(commandcode, binaryToPulse)
      return "#{id}#{commandcode}02"
  }
