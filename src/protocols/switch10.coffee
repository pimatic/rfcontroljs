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
      # pulses is something like: '01100110011010101001101010010101100112'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '101010000100011101'
      # now we extract the data from that string
      # | 10101000|01000111| 0     |1
      # | ID?     |unit?   | State |?
      
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
