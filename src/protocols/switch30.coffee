module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0': '0' #binary 0
    '1': '1' #binary 1
    '2': ''  #footer
  }
  binaryToPulse = {
    '0': '0'
    '1': '1'
  }
  return protocolInfo = {
    name: 'switch30'
    type: 'switch'
    commands: ["arm", "dis", "byp", "sos"]
    values:
      id:
        type: "number"
      unit:
        type: "number"
      command:
        type: "string"
    brands: ["JP-05"] # Keypad
    pulseLengths: [ 520, 1468, 13312 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      #message example
      # 01010101010110100101101001001110101001010101010102
      # 01010101010110100101101001001110 1010010101010101 02 arm
      # 01010101010110100101101001001110 0101010110100101 02 dis
      # 01010101010110100101101001001110 0101010101011010 02 byp
      # 01010101010110100101101001001110 0101101001010101 02 sos
      #| 0101010101011010 | 0101101001001110 | 1010010101010101 | 02
      #| id (16)          | unit(16)         | command(16)      | footer (2)

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      id = helper.binaryToNumber(binary, 0, 15)
      unit = helper.binaryToNumber(binary, 16, 31)
      commandcode = pulses[32..47]
      switch commandcode
        when "1010010101010101" then command = "arm"
        when "0101010110100101" then command = "dis"
        when "0101010101011010" then command = "byp"
        when "0101101001010101" then command = "sos"
      return result= {
        id: id,
        unit: unit,
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse)
      unit = helper.map(helper.numberToBinary(message.unit, 16), binaryToPulse)
      switch message.command
        when "arm" then commandcode = "1010010101010101"
        when "dis" then commandcode = "0101010110100101"
        when "byp" then commandcode = "0101010101011010"
        when "sos" then commandcode = "0101101001010101"
      return "#{id}#{unit}#{commandcode}02"
  }
