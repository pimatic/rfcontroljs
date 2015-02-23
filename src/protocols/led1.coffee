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
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["LED Stripe RF Dimmer (no name)"]
    pulseLengths: [348, 1051, 10864]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01011010010101100110011010101001010110010101100102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101000010101000001000010'
      # now we extract the data from that string
      # | 101000010101000001000 |   010   |
      # | ID                    | command |
      commandcode = binary[21..23]
      switch commandcode
        when "001" then command = "on/off"
        when "100" then command = "up"
        when "010" then command = "down"
        else command = "unkown command #{commandcode}"
      return result= {
        id: helper.binaryToNumber(binary, 0, 20)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 21), binaryToPulse)
      switch message.command
        when "on/off" then commandcode = "001"
        when "up" then commandcode = "100"
        when "down" then commandcode = "010"
        else return "0" #it would be better to throw a failure there
      return "#{id}#{commandcode}02"
  }
