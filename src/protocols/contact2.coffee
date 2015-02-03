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
    name: 'contact2'
    type: 'pir'
    values:
      id:
        type: "number"
      contact:
        type: "boolean"
    brands: ["No brand"]
    pulseLengths: [295, 886, 9626]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 19)
        contact: false
      }
  }
