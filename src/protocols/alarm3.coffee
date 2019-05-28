module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '10' #binary 0
    '01': '01' #binary 1
    '02': ''  #footer
    '12': ''  #footer
    '00': ''  #footer
    '11': ''  #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '02'
  }
  return protocolInfo = {
    name: 'alarm3'
    type: 'switch'
    values:
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["Smartwares RM174RF (provisional)"]
    pulseLengths: [ 472, 1236, 11688 ]
    pulseCount: 54
    decodePulses: (pulses) ->
      # pulses is something like: '10 01 01 01 01 01 10 01 01 01 10 10 01 01 01 10 10 10 10 10 01 01 10 10 000102'
      #                            10 01 01 01 01 01 10 01 01 01 10 10 01 01 01 10 10 10 10 10 01 01 10 10 000102
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)

      return result = {
        id: helper.binaryToNumber(binary, 0, 23)
        state: true
      }
    encodeMessage: (message) ->
      if message.state is false then return "0"
      unit = helper.map(helper.numberToBinary(message.id, 24), binaryToPulse)
      return "{unit}000102"
  }
