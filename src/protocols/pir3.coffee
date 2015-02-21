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
    name: 'pir3'
    type: 'pir'
    values:
      unit:
        type: "binary"
      presence:
        type: "boolean"
    brands: []
    pulseLengths: [ 496, 1471, 6924 ]
    pulseCount: 66
    decodePulses: (pulses) ->
      # pulses is something like: '011010011010010110101010010101101010011001100110100101100101101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like '10010011000011100010101001101100'
      return result = {
        unit: binary
        presence: true
      }
  }
