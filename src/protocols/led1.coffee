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
    name: 'led1'
    type: 'command'
    commands: ["on/off","up","down"]
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["LED Stripe RF Dimmer (no name)"]
    pulseLengths: [ 439, 1240, 12944 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01011010010101100110011010101001010110010101100102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101000010101000001000010'
      # now we extract the data from that string
      # | 101000010101000001000 |   010   |
      # | ID                    | command |
      commandcode = binary[16..23]
      switch commandcode
        when "00100001" then command = "on/off"
        when "00100100" then command = "up"
        when "00100010" then command = "down"
        else command = "code:#{commandcode}"
      return result= {
        id: helper.binaryToNumber(binary, 0, 15)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse)
      switch message.command
        when "on/off" then commandcode = "00100001"
        when "up"     then commandcode = "00100100"
        when "down"   then commandcode = "00100010"
        else #this gives the ability for personal commands
          if message.command[0..4] is "code:"
            commandcode = message.command[5..]
      commandcode = helper.map(commandcode, binaryToPulse)
      return "#{id}#{commandcode}02"
  }