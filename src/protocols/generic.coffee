module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0102': '1' #binary 0
    '0201': '0' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'generic'
    type: 'generic'
    values:
      id:
        type: "number"
      type:
        type: "number"
      positive:
        type: "boolean"
      value:
        type: "number"
    brands: ["homemade"]
    pulseLengths: [ 671, 2049, 4346, 10208 ]
    pulseCount: 198
    decodePulses: (pulses) ->
      # pulses could be:
      # '0201020102010201010201020102010201020201010202010201020101020201010202010102020102010201
      #  0201020102010201020102010201020102010201020102010201020102010201020102010201020102010201
      #  0201020102010201010203'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 13)
        type: helper.binaryToNumber(binary, 14 , 17)
        positive: helper.binaryToBoolean(binary, 18, 18)
        value: helper.binaryToNumber(binary, 19, 48)
      }
  }
