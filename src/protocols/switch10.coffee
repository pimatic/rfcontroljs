module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '01': '1' #binary 1
    '00': '0' #binary 0
    '02': ''  #footer
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
      id:
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
      # pulses is something like:
      # '0101000000010101010000010001010101000000010101010000010100'+
      # '0100000101000101010001000100010001010001000101000000010102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like:
      # '11000111100 1011110001111001101001101110101010110101100011'
      # now we extract the data from that string
      # | 11000111100 10111100011110011010011011101010   1011    01       01      100011
      # | ?          |     systemcode                  | group | state | group2 |  unit
      
      groupRes = true
      groupcode = helper.binaryToNumber(binary, 43, 46)
      groupcode2 = helper.binaryToNumber(binary, 49, 50)
      
      if groupcode is 11 and groupcode2 is 1
        groupRes = false
      else if groupcode is 12 and groupcode2 is 3
        groupRes = true
      
      id = helper.binaryToNumber(binary, 11, 42)>>>0
      
      return result = {
        id: id
        unit: helper.binaryToNumber(binary, 51, 56)
        all: groupRes
        state: helper.binaryToBoolean(binary, 47)
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 32), binaryToPulse)
      
      if message.state is true
        state = helper.map(helper.numberToBinary(2, 2), binaryToPulse)
      else
        state = helper.map(helper.numberToBinary(1, 2), binaryToPulse)
      
      unit = helper.map(helper.numberToBinary(message.unit, 6), binaryToPulse)
      
      if message.all is true
        groupcode = helper.map(helper.numberToBinary(12, 4), binaryToPulse)
        groupcode2 =  helper.map(helper.numberToBinary(3, 2), binaryToPulse)
      else
        groupcode = helper.map(helper.numberToBinary(11, 4), binaryToPulse)
        groupcode2 =  helper.map(helper.numberToBinary(1, 2), binaryToPulse)
	  
      header = "0101000000010101010000"

      return "#{header}#{id}#{groupcode}#{state}#{groupcode2}#{unit}02"
  }
