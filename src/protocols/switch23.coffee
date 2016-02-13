module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '0' #binary 0
    '01': '1' #binary 1
    '2': '' #footer
  }
  binaryToPulse = {
    '1': '01'
    '0': '10'
  }
  return protocolInfo = {
    name: 'switch23'
    type: 'command'
    commands: ["A","B","C","D"]
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["Atag Cocking hood", "TXS4 Transmitter"]
    pulseLengths: [350, 720, 16000]
    pulseCount: 38
    decodePulses: (pulses) ->
      # pulses is something like: '00110011001100110011010100110011001012'
      # we first map the sequences to binary
      binary = helper.map(pulses[1..37], pulsesToBinaryMapping)
      # binary is now something like: '101010101000101011'
      # now we extract the temperature and humidity from that string
      # | 10101010100010 | 1011    |
      # | ID             | command |
      id = helper.binaryToNumber(binary, 0, 13)
      commandcode = binary.slice(14, 18)
      command = (
        switch commandcode
          when '1110' then 'A'
          when '1100' then 'B'
          when '1011' then 'C'
          when '1001' then 'D'
      )
      return result = {
        id: id
        command: command
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 14), binaryToPulse)
      commandcode = (
        switch message.command
          when 'A' then '1110'
          when 'B' then '1100'
          when 'C' then '1011'
          when 'D' then '1001'
          else '1110'
      )
      commandcode = helper.map(commandcode, binaryToPulse)
      return "0#{id}#{commandcode}2"
  }
