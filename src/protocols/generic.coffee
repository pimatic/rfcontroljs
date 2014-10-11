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
      proto:
        type: "number"
      positive:
        type: "boolean"
      counter:
        type: "number"
    brands: ["homemade"]
    pulseLengths: [ 671, 2049, 4346, 10208 ]
    pulseCount: 198
    decodePulses: (pulses) ->
      # pulses could be:
      # '020102010201020101020102010201020102020101020201020102010102020101020201010202010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201010203'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 13) 
        proto: helper.binaryToNumber(binary, 14 , 17)
        positive: helper.binaryToNumber(binary, 18, 18)
        counter: helper.binaryToNumber(binary, 19, 48)
      }
  }
