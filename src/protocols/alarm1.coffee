module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '30': ''
    '01': '0' #binary 0
    '02': '1' #binary 1
    '04': ''    #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '02'
  }
  return protocolInfo = {
    name: 'alarm1'
    type: 'switch'
    values:
      unit:
        type: "number"
      id:
        type: "number"
      presence:
        type: "boolean"
    brands: ["FA20RF"]
    pulseLengths: [ 800, 1423, 2760, 8040, 13000 ]
    pulseCount: 52
    decodePulses: (pulses) ->
      # pulses is something like: '01010110010101100110011001100110010101100110011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '10100 00010 00'
      # now we extract the temperature and humidity from that string
      # |    10100 | 00010 |      0 |    0 |
      # |     Unit |    ID |  fixed | State|
      return result = {
        unit: helper.binaryToNumber(binary, 0, 23)
        state: true
      }
    encodeMessage: (message) ->
      if message.state == false then return "0"
      
      unit = helper.map(helper.numberToBinary(message.unit, 24), binaryToPulse)
      
      pulses = ""
      pulse = "30#{unit}0430#{unit}"
      
      i = 0
      while i <= 5
        i++
        pulses += "#{pulses}#{pulse}"
      
      return  pulses;
  }
