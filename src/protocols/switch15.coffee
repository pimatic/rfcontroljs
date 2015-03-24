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
      unitCode = helper.binaryToNumberLSBMSB(binary, 21, 23)
      state = helper.binaryToBoolean(binary, 20)
      all = false
      unit = (
        switch unitCode
          when 7 then 1
          when 6 then 2
          when 5 then 3
          when 3 then 4
          else
            all = true
            state = !state
            0 #return value for unit
      )
      return result = {
        id:    helper.binaryToNumber(binary, 0, 19)
        unit:  unit
        state: state
        all:   all
      }
    encodeMessage: (message) ->
      id = helper.numberToBinary(message.id, 20)
      if message.all
        unitCode = 0
        state = not message.state
      else
        unitCode = (
          switch message.unit
            when 1 then 7
            when 2 then 6
            when 3 then 5
            when 4 then 3
        )
        state = message.state
      state = (if state then '1' else '0')
      unit = helper.numberToBinaryLSBMSB(unitCode, 3)
      rfstring = "#{id}#{state}#{unit}"
      rfstring = helper.map(rfstring, binaryToPulse)
      return "#{rfstring}02"
  }
