module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '0' #binary 0
    '01': '1' #binary 1
    '02': '' #footer
  }
  binaryToPulse = {
    '1': '01'
    '0': '10'
  }
  return protocolInfo = {
    name: 'switch22'
    type: 'command'
    values:
      id:
        type: "number"
      command:
        type: "string"
    brands: ["Relay 4CH switch"]
    pulseLengths: [376, 1144, 11720]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01100110101010101001100101010101101010010110010102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101000000101111100011011'
      # now we extract the temperature and humidity from that string
      # | 10100000010111110001 | 1011    |
      # | ID                   | command |
      id = helper.binaryToNumber(binary, 0, 19)
      commandcode = binary.slice(20, 24)
      command = (
        switch commandcode
          when '1110' then 'A'
          when '1101' then 'B'
          when '1011' then 'C'
          when '0111' then 'D'
      )
      return result = {
        id: id
        command: command
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 20), binaryToPulse)
      commandcode = (
        switch message.command
          when 'A' then '1110'
          when 'B' then '1101'
          when 'C' then '1011'
          when 'D' then '0111'
      )
      commandcode = helper.map(commandcode, binaryToPulse)
      return "#{id}#{commandcode}02"
  }
