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
    name: 'dimmer2'
    type: 'dimmer'
    values:
      remoteCode:
        type: "number"
      unitCode:
        type: "number"
      state:
        type: "boolean"
      dimlevel:
        type: "number"
        min: 0
        max: 31
    brands: ["LightwaveRF"]
    pulseLengths: [204, 328, 1348, 10320]
    pulseCount: 144
    decodePulses: (pulses) ->
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)

      _remoteCode = helper.binaryToNumber(binary, 29, 35)
      remoteCode = nibbleToNumber(_remoteCode) * 1048576
      _remoteCode = helper.binaryToNumber(binary, 36, 42)
      remoteCode = remoteCode + nibbleToNumber(_remoteCode) * 65536
      _remoteCode = helper.binaryToNumber(binary, 43, 49)
      remoteCode = remoteCode + nibbleToNumber(_remoteCode) * 4096
      _remoteCode = helper.binaryToNumber(binary, 50, 56)
      remoteCode = remoteCode + nibbleToNumber(_remoteCode) * 256
      _remoteCode = helper.binaryToNumber(binary, 57, 63)
      remoteCode = remoteCode + nibbleToNumber(_remoteCode) * 16
      _remoteCode = helper.binaryToNumber(binary, 64, 70)
      remoteCode = remoteCode + nibbleToNumber(_remoteCode)
      
      _unitCode = helper.binaryToNumber(binary, 15, 21)
      unitCode = nibbleToNumber(_unitCode)

      _state = helper.binaryToNumber(binary, 22, 28)
      nstate = nibbleToNumber(_state)
      if nstate
        state = true
      else
        state = false

      _dimlevel = helper.binaryToNumber(binary, 1, 7)
      dimlevel = nibbleToNumber(_dimlevel) * 16
      _dimlevel = helper.binaryToNumber(binary, 8, 14)
      dimlevel = dimlevel + nibbleToNumber(_dimlevel)

      return result = {
        remoteCode: remoteCode,
        unitCode: unitCode,
        state: state,
        dimlevel: dimlevel
      }
    encodeMessage: (message) ->
      if message.dimlevel > 0 and message.dimlevel <= 31
        _level = message.dimlevel + 0x80
        _state = true
      else
        _level = 0
        _state = false

      _level1 = numberToNibble((_level//16) & 0x0F)
      level1 = helper.map(helper.numberToBinary(_level1, 7), binaryToPulse)
      _level2 = numberToNibble(_level & 0x0F)
      level2 = helper.map(helper.numberToBinary(_level2, 7), binaryToPulse)

      _unitCode = numberToNibble(message.unitCode)
      unitCode = helper.map(helper.numberToBinary(_unitCode, 7), binaryToPulse)

      if _state
        command = helper.map(helper.numberToBinary(0x76, 7), binaryToPulse)
      else
        command = helper.map(helper.numberToBinary(0x7A, 7), binaryToPulse)

      _id1 = numberToNibble((message.remoteCode//1048576) & 0x0F)
      id1 = helper.map(helper.numberToBinary(_id1, 7), binaryToPulse)
      _id2 = numberToNibble((message.remoteCode//65536) & 0x0F)
      id2 = helper.map(helper.numberToBinary(_id2, 7), binaryToPulse)
      _id3 = numberToNibble((message.remoteCode//4096) & 0x0F)
      id3 = helper.map(helper.numberToBinary(_id3, 7), binaryToPulse)
      _id4 = numberToNibble((message.remoteCode//256) & 0x0F)
      id4 = helper.map(helper.numberToBinary(_id4, 7), binaryToPulse)
      _id5 = numberToNibble((message.remoteCode//16) & 0x0F)
      id5 = helper.map(helper.numberToBinary(_id5, 7), binaryToPulse)
      _id6 = numberToNibble(message.remoteCode & 0x0F)
      id6 = helper.map(helper.numberToBinary(_id6, 7), binaryToPulse)

      return "01#{level1}#{level2}#{unitCode}#{command}#{id1}#{id2}#{id3}#{id4}#{id5}#{id6}03"
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