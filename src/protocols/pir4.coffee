module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0': '0' #binary 0
    '1': '1' #binary 1
    '2': ''    #footer
  }
  binaryToPulse = {
    '0': '0'
    '1': '1'
  }
  return protocolInfo = {
    name: 'pir4'
    type: 'pir'
    values:
      id:
        type: "number"
      presence:
        type: "boolean"
    brands: []
    pulseLengths: [ 371, 1081, 5803 ]
    pulseCount: 36
    decodePulses: (pulses) ->
      # pulses is something like: '011010011010010110101010010101101010011001100110100101100101101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like '10010011000011100010101001101100'
      return result = {
        id: helper.binaryToNumber(binary, 0, 15)
        unit: helper.binaryToNumber(binary, 16, 31)
        presence: true
      }
  }
