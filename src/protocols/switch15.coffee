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
    name: 'switch15'
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
    brands: ["Daycom Switches"]
    pulseLengths: [ 300, 914, 9624 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01101001011001100110010110011010101001011010101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '000000000000000000001100'
      # now we extract the data from that string
      # 00000000000000000000| 1   |100
      #    ID               |State|Unit
      unit = (8 - helper.binaryToNumberLSBMSB(binary, 21, 23))
      all = false
      if unit is 8
        unit = 0
        all = true

      return result = {
        id:    helper.binaryToNumber(binary, 0, 19)
        unit:  unit
        state: helper.binaryToBoolean(binary, 20)
        all:   all
      }
    encodeMessage: (message) ->
      id = helper.numberToBinary(message.id, 20)
      state = (if message.state then '1' else '0')
      unit = helper.numberToBinaryLSBMSB(8 - message.unit, 3)
      if message.all?
        if message.all is true
          unit = helper.numberToBinaryLSBMSB(0, 3)

      rfstring = "#{id}#{state}#{unit}"
      rfstring = helper.map(rfstring, binaryToPulse)
      return "#{rfstring}02"
  }
