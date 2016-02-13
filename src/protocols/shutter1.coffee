module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '32': ''  #header
    '01': '0' #binary 0
    '10': '1' #binary 1
    '14': ''  #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'shutter1'
    type: 'command'
    commands: ["up","down","stop"]
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["Nobily"]
    pulseLengths: [280, 736, 1532, 4752, 7796]
    pulseCount: 164
    decodePulses: (pulses) ->
      # pulses for up, down and stop are something like:
      #32
      #01011001010101100101010101010110011010100101101010010110010101
      #10010101
      #10010101
      #10
      #32
      #01011001010101100101010101010110011010100101101010010110010101
      #10010101
      #10010101
      #14

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '0010000100000001011100111001000     10011001'
      # now we extract the data from that string
      # | 0010000100000001011100111001000 | 1000     | 1000     |
      # | ID                              | command  | command  |
      #
      # | 1     |
      # | fixed |
      #
      # | 0010000100000001011100111001000 | 1000     | 1000     |
      # | ID                              | command  | command  |

      commandcode = binary[31..34]
      command = (
        switch commandcode
          when '1000' then 'up'
          when '1001' then 'down'
          when '1010' then 'stop'
      )
      return result= {
        id: helper.binaryToNumber(binary, 0, 30)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 31), binaryToPulse)
      commandcode = (
        switch message.command
          when 'up'  then '1000'
          when 'down' then '1001'
          when 'stop' then '1010'
      )
      commandcode = helper.map(commandcode, binaryToPulse)

      return "32#{id}#{commandcode}#{commandcode}1032#{id}#{commandcode}#{commandcode}14"
  }
