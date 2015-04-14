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
    name: 'alarm1'
    type: 'switch'
    values:
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["FA20RF"]
    pulseLengths: [ 800, 1423, 2760, 8040, 13000 ]
    pulseCount: 52
    decodePulses: (pulses) ->
      # pulses is something like: '3002020101010102020201010101020101010102020202010204'
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
