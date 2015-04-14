module.exports = (helper) ->
  # mapping for decoding
  pulsesToBinaryMapping = {
    '10': '1' #binary 1
    '01': '0' #binary 0
    '02': ''  #footer
  }
  # same for send
  binaryToPulse = {
    '1': '10'
    '0': '01'
  }
  return protocolInfo = {
    name: 'switch14'
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
    brands: ["UNITEC"]
    pulseLengths: [ 209, 623, 6288 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010101010101010101010101010101010101011010010102'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '000000000000000000001100'
      # now we extract the data from that string
      # 00000000000000000000| 11 |  0 |0
      #    ID               |Unit|!All|State

      return result = {
        id:    helper.binaryToNumber(binary, 0, 19)
        unit:  (4 - helper.binaryToNumberLSBMSB(binary, 20, 21))
        all:   !helper.binaryToBoolean(binary, 22)
        state: helper.binaryToBoolean(binary, 23)
      }
    encodeMessage: (message) ->
      id = helper.numberToBinary(message.id, 20)
      state = (if message.state then '1' else '0')
      all = '1'
      if message.all?
        if message.all is true
          all = '0'
      unit = helper.numberToBinaryLSBMSB(4 - message.unit, 2)
      rfstring = "#{id}#{unit}#{all}#{state}"
      rfstring = helper.map(rfstring, binaryToPulse)
      return "#{rfstring}02"
  }
