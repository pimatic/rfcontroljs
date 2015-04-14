module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '1' #binary 1
    '01': '0' #binary 0
    '2' : ''  #footer
  }
  # same for send
  binaryToPulse = {
    '1': '10'
    '0': '01'
  }
  return protocolInfo = {
    name: 'switch13'
    type: 'switch'
    values:
      id:
        type: "number"
      unit:
        type: "number"
      state:
        type: "boolean"
      all:
        type: "boolean"
      dimm:
        type: "boolean"
    brands: ["Aldi Quigg GT-7000", "Globaltronics GT-FSI-04a"]
    pulseLengths: [ 700, 1400, 81000 ]
    pulseCount: 42
    decodePulses: (pulses) ->
      # pulses is something like: '001100110101001010101010101010110100110102'
      # we first map the sequences to binary
      binary = helper.map(pulses[1..], pulsesToBinaryMapping)
      # binary is now something like: '01011100000000010001'
      # now we extract the data from that string
      # | 010111000000| 00 | 0 |  1  | 0  | 0  |  0    |  1
      # |     ID      |unit|all|state|dimm|zero|unitref|parity
      paritybit = helper.binaryToBoolean(binary, 19)
      paritybitRef = helper.createParityBit(binary[12..18])

      if paritybit isnt paritybitRef
        return result = {
          paritybit:paritybit
          paritybitRef:paritybitRef
          parity:parity
          binary:binary
        }  #what happens, when we dont return something?

      return result = {
        id:    helper.binaryToNumber(binary, 0, 11)
        unit:  helper.binaryToNumber(binary, 12, 13)
        all:   helper.binaryToBoolean(binary, 14)
        state: helper.binaryToBoolean(binary, 15)
        dimm:  helper.binaryToBoolean(binary, 16)
      }
    encodeMessage: (message) ->
      id = helper.numberToBinary(message.id, 12)
      state = (if message.state then '1' else '0')
      all = '0'
      if message.all?
        if message.all is true
          all = '1'
      dimm = '0'
      if message.dimm?
        if message.dimm is true
          dimm = '1'
      unit = helper.numberToBinary(message.unit, 2)
      bit18 = unit[0]
      rfstring = "#{id}#{unit}#{all}#{state}#{dimm}0#{bit18}"

      parity = helper.createParityBit(rfstring[12..])
      paritybit = (if parity then binaryToPulse['1'] else binaryToPulse['0'])
      rfstring = helper.map(rfstring, binaryToPulse)
      return "0#{rfstring}#{paritybit}2"
  }
