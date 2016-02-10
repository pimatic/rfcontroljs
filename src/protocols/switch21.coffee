module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '1' #binary 1
    '02': '0' #binary 0
    '03': ''  #footer
  }
  binaryToPulse = {
    '0': '02'
    '1': '01'
  }
  return protocolInfo = {
    name: 'switch21'
    type: 'switch'
    values:
      remoteCode:
        type: "number"
      unitCode:
        type: "number"
      state:
        type: "boolean"
    brands: ["LightwaveRF"]
    pulseLengths: [204, 328, 1348, 10320]
    pulseCount: 144
    decodePulses: (pulses) ->
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)

      unitCode = nibbleToNumber(helper.binaryToNumber(binary, 15, 21))

      nstate = nibbleToNumber(helper.binaryToNumber(binary, 22, 28))
      if nstate
        state = true
      else
        state = false

      remoteCode = nibbleToNumber(helper.binaryToNumber(binary, 29, 35)) * 1048576
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 36, 42)) * 65536
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 43, 49)) * 4096
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 50, 56)) * 256
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 57, 63)) * 16
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 64, 70))

      return result = {
        remoteCode: remoteCode,
        unitCode: unitCode,
        state: state
      }
    encodeMessage: (message) ->
      # level should be 0 when switching on/off
      level = helper.map(helper.numberToBinary(0x7A, 7), binaryToPulse)

      unitCode = helper.map(helper.numberToBinary(numberToNibble(message.unitCode), 7), binaryToPulse)

      if message.state
        state = helper.map(helper.numberToBinary(0x76, 7), binaryToPulse)
      else
        state = helper.map(helper.numberToBinary(0x7A, 7), binaryToPulse)

      id1 = helper.map(helper.numberToBinary(numberToNibble((message.remoteCode//1048576) & 0x0F), 7), binaryToPulse)
      id2 = helper.map(helper.numberToBinary(numberToNibble((message.remoteCode//65536) & 0x0F), 7), binaryToPulse)
      id3 = helper.map(helper.numberToBinary(numberToNibble((message.remoteCode//4096) & 0x0F), 7), binaryToPulse)
      id4 = helper.map(helper.numberToBinary(numberToNibble((message.remoteCode//256) & 0x0F), 7), binaryToPulse)
      id5 = helper.map(helper.numberToBinary(numberToNibble((message.remoteCode//16) & 0x0F), 7), binaryToPulse)
      id6 = helper.map(helper.numberToBinary(numberToNibble(message.remoteCode & 0x0F), 7), binaryToPulse)

      return "01#{level}#{level}#{unitCode}#{state}#{id1}#{id2}#{id3}#{id4}#{id5}#{id6}03"
  }

nibbleToNumber = (nibble) ->
  number = (
    switch nibble
      when 0x7A then 0x00
      when 0x76 then 0x01
      when 0x75 then 0x02
      when 0x73 then 0x03
      when 0x6E then 0x04
      when 0x6D then 0x05
      when 0x6B then 0x06
      when 0x5E then 0x07
      when 0x5D then 0x08
      when 0x5B then 0x09
      when 0x57 then 0x0A
      when 0x3E then 0x0B
      when 0x3D then 0x0C
      when 0x3B then 0x0D
      when 0x37 then 0x0E
      when 0x2F then 0x0F
  )

numberToNibble = (number) ->
  nibble = (
    switch number
      when 0x00 then 0x7A
      when 0x01 then 0x76
      when 0x02 then 0x75
      when 0x03 then 0x73
      when 0x04 then 0x6E
      when 0x05 then 0x6D
      when 0x06 then 0x6B
      when 0x07 then 0x5E
      when 0x08 then 0x5D
      when 0x09 then 0x5B
      when 0x0A then 0x57
      when 0x0B then 0x3E
      when 0x0C then 0x3D
      when 0x0D then 0x3B
      when 0x0E then 0x37
      when 0x0F then 0x2F
  )