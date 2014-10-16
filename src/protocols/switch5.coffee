module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '0' #binary 0
    '01': '1' #binary 1
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '10'
    '1': '01'
  }
  return protocolInfo = {
    name: 'switch5'
    type: 'switch'
    values:
      id:
        type: "number"
      all:
        type: "number"
      unit:
        type: "number"
      state:
        type: "boolean"
    brands: ["Eurodomest"]
    pulseLengths: [295, 886, 9626]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '10010101101010010110010110101001010101011010101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '011100011011000111110000'
      # now we extract the temperature and humidity from that string
      # | 01110001101100011111 | 000      | 0              |
      # | ID                   | UnitCode | inverted state |
      id = helper.binaryToNumber(binary, 0, 19)
      unitCode = helper.binaryToNumber(binary, 20, 22)
      state = !helper.binaryToBoolean(binary, 23)
      all = false
      unit = (
        switch unitCode
          when 0 then 1
          when 1 then 2
          when 2 then 3
          when 4 then 4
          else all = true; 0
      )
      if all
        state = not state
      return result = {
        id: id
        unit: unit
        all: all
        state: state
      }
    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 20), binaryToPulse)
      if message.all
        unitCode = (if message.state then 6 else 7)
        state = not message.state
      else
        unitCode = (
          switch message.unit
            when 1 then 0
            when 2 then 1
            when 3 then 2
            when 4 then 4
        )
        state = message.state
      unitCode = helper.map(helper.numberToBinary(unitCode, 3), binaryToPulse)
      inverseState = (if state then binaryToPulse['0'] else binaryToPulse['1'])
      return "#{id}#{unitCode}#{inverseState}02"
  }