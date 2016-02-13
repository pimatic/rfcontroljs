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
    name: 'awning2'
    type: 'command'
    commands: ["in", "out", "stop"]
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["Soluna"]
    pulseLengths: [359, 718, 1532, 4740, 10048]
    pulseCount: 82
    decodePulses: (pulses) ->
      # pulses for out, in and stop are something like:
      #3210101010011010010101101001010101100101011010100110011010010101100101011001010114

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '111101100011000010001110101100010001000'
      # now we extract the data from that string
      # | 1111011000110000100011101011000 | 10   | 001000  |
      # | ID                              | fix  | command |

      commandcode = binary[33..38]
      command = (
        switch commandcode
          when '001000' then 'in'
          when '011001' then 'out'
          when '101010' then 'stop'
      )
      return result= {
        id: helper.binaryToNumber(binary, 0, 30)
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 31), binaryToPulse)
      commandcode = (
        switch message.command
          when 'in'  then '001000'
          when 'out' then '011001'
          when 'stop' then '101010'
      )
      commandcode = helper.map(commandcode, binaryToPulse)

      return "32#{id}1001#{commandcode}14"
  }
