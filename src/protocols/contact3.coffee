module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '10': '0' #binary 0
    '01': '1' #binary 1
    '02': ''  #footer
  }
  binaryToPulse = {
    '0': '10'
    '1': '01'
  }
  return protocolInfo = {
    name: 'contact3'
    type: 'contact'
    values:
      id:
        type: "number"
      contact:
        type: "boolean"
    brands: ["Home Easy HE852"]
    pulseLengths: [310, 950, 9644]
    pulseCount: 50
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 19)
        contact: helper.binaryToBoolean(binary, 23)
      }
  }
