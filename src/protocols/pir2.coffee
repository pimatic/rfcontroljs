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
    name: 'pir2'
    type: 'pir'
    values:
      unit:
        type: "number"
      id:
        type: "number"
      presence:
        type: "boolean"
    brands: ["Multi Kon Trade (B00RTDMC4S)"]
    pulseLengths: [ 451, 1402, 14356 ]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '01010110010101100110011001100110010101100110011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '10100 00010 00'
      # now we extract the temperature and humidity from that string
      # |    10100 | 00010 |      0 |    0 |
      # |     Unit |    ID |  fixed | State|
      return result = {
        unit: helper.binaryToNumber(binary, 0, 4)
        id: helper.binaryToNumber(binary, 5, 9)
        presence: true
      }
  }
