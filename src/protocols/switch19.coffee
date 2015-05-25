module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '10': '1' #binary 1
    '02': ''  #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'switch19'
    type: 'switch'
    values:
      id:
        type: "string"
      unit:
        type: "number"
      state:
        type: "boolean"
    brands: ["REV Switch 008342 and Dimmer 008343"]
    pulseLengths: [472, 1436, 14776]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '10010101101010010110010110101001010101011010101002'
      binary = helper.map(pulses, pulsesToBinaryMapping)
      idcode = binary[0..4]
      id = (
        switch idcode
          when '11010' then 'A'
          when '01110' then 'B'
          when '01011' then 'C'
          when '01010' then 'D'
      )
      unitcode = binary[8..15]
      unit = (
        switch unitcode
          when '11010100' then 1
          when '01110100' then 2
          when '01010111' then 3
      )
      statecode = binary[20..23]
      state = (
        switch statecode
          when '0011' then false
          when '1100' then true
      )
      return result = {
        id: id
        unit: unit
        state: state
      }

    encodeMessage: (message) ->
      idbin = (
        switch message.id
          when 'A' then '11010'
          when 'B' then '01110'
          when 'C' then '01011'
          when 'D' then '01010'
      )
      id = helper.map(idbin, binaryToPulse)

      unitbin = (
        switch message.unit
          when 1 then '11010100'
          when 2 then '01110100'
          when 3 then '01010111'
      )
      unit = helper.map(unitbin, binaryToPulse)

      statebin = (
        switch message.state
          when false then '0011'
          when true then '1100'
      )
      state = helper.map(statebin, binaryToPulse)

      return "#{id}100110#{unit}01010101#{state}02"
  }
