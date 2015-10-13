module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '10': '1' #binary 1
    '02': ''  #footer
  }
  return protocolInfo = {
    name: 'generic2'
    type: 'generic'
    values:
      id:
        type: "number"
      node_type:
        type: "number"
      data:
        type: "number"
      freq:
        type: "number"
      battery_level:
        type: "number"
      checksum:
        type: "boolean"
    brands: ["homemade"]
    pulseLengths: [ 480, 1320, 13320 ]
    pulseCount: 66
    decodePulses: (pulses) ->
      # pulses could be:
      #  10 10 01 10 10 10 10 01 10 10 10 10 10 01 01 01 01 01 10 10 10 10 10 10 01 10 10 10 10 10 10 10 02
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumberLSBMSB(binary, 24, 31)
        node_type: helper.binaryToNumberLSBMSB(binary, 20, 23)
        data: helper.binaryToNumberLSBMSB(binary, 10, 19)
        freq: helper.binaryToNumberLSBMSB(binary, 6, 9)
        battery_level: helper.binaryToNumberLSBMSB(binary, 4, 5)
        checksum: helper.hexChecksum(binary)
      }
  }
