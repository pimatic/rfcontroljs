module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '30': ''  #header
    '01': '0' #binary 0
    '02': '1' #binary 1
    '04': ''  #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '02'
  }
  return protocolInfo = {
    name: 'alarm2'
    type: 'switch'
    values:
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["FA21RF"]
    pulseLengths: [ 805, 1377, 2710, 8104, 22564 ]
    pulseCount: 52
    decodePulses: (pulses) ->
      # pulses is something like: '3002010101020102020201010101010102010101010201010104'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      
      return result = {
        id: helper.binaryToNumber(binary, 0, 23)
        state: true
      }
    encodeMessage: (message) ->
      if message.state is false then return "0"
      unit = helper.map(helper.numberToBinary(message.id, 24), binaryToPulse)
      return "30#{unit}0430#{unit}0430#{unit}04"
  }
