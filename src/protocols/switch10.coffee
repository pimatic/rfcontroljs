module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '01': '1' #binary 1
    '00': '0' #binary 0
    '02': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '1': '01'
    '0': '00'
  }
  return protocolInfo = {
    name: 'switch10'
    type: 'switch'
    values:
      systemcode:
        type: "number"
      state:
        type: "boolean"
      all:
        type: "boolean"
      unit:
        type: "number"
    brands: ["Easy Home Advanced"]
    pulseLengths: [ 271, 1254, 10092 ]
    pulseCount: 116
    decodePulses: (pulses) ->
      # pulses is something like: '01010000000101010100000100010101010000000101010100000101000100000101000101010001000100010001010001000101000000010102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '11000111100 1011110001111001101001101110101010110101100011'
      # now we extract the data from that string
      # | 11000111100 10111100011110011010011011101010   1011    01       01      100011
      # | ?          |     systemcode                  | group | state | group2 |  unit
      
      groupRes = 1
      groupcode = helper.binaryToNumber(binary, 43, 46)
      groupcode2 = helper.binaryToNumber(binary, 49, 50)
      
      if groupcode == 11 and groupcode2 == 1
        groupRes = false
      else if groupcode == 2 and groupcode2 == 3
        groupRes = true
      
      id2 = helper.binaryToNumber(binary, 11, 42)>>>0
      
      return result = {
        systemcode: id2
        unit: helper.binaryToNumber(binary, 51, 56)
        all: groupRes
        state: if helper.binaryToNumber(binary, 47, 48) == 1 then false else true
      }
    encodeMessage: (message) ->
      systemcode = helper.map(helper.numberToBinary(message.systemcode, 32), binaryToPulse)
      
      state = if message.state then helper.map(helper.numberToBinary(2, 2), binaryToPulse)
      else helper.map(helper.numberToBinary(1, 2), binaryToPulse)
      
      unit = helper.map(helper.numberToBinary(message.unit, 6), binaryToPulse)
      
      groupcode = if message.all then helper.map(helper.numberToBinary(3, 4), binaryToPulse)
      else helper.map(helper.numberToBinary(11, 4), binaryToPulse)
      
      groupcode2 = if message.all then helper.map(helper.numberToBinary(3, 2), binaryToPulse)
      else helper.map(helper.numberToBinary(1, 2), binaryToPulse)
	  
      header = helper.map("11000111100", binaryToPulse)

      return "#{header}#{systemcode}#{groupcode}#{state}#{groupcode2}#{unit}0102"
  }
