module.exports = (helper) ->
# derived from switch13, just pulseLengths differ
# fixme - added mechanism to use/reuse another protocol
# implementation to avoid code duplication
# mapping for decoding
  pulsesToBinaryMapping = {
    '11': '0' #binary 1
    '10': '0' #binary 1
    '01': '1' #binary 0
    '00': '1' #binary 0
    '2' : ''  #footer
  }
  # same for send
  binaryToPulse = {
    '1': '01'
    '0': '11'
  }
  return protocolInfo = {
    name: 'switch34'
    type: 'switch'
    values:
      id:
        type: "number"
#      unit:
#        type: "number"
      state:
        type: "boolean"
#      all:
#        type: "boolean"
#      dimm:
#        type: "boolean"
    brands: ["conecto SA-CC50132"]
    pulseLengths: [ 316, 844, 10360 ]
    pulseCount: 68
    decodePulses: (pulses) ->
      # pulses is something like: '01010101101010011001010101011010010101011010101010010101011001010102'
      # map pulses to binary, first pulse skipped
      binary = helper.map(pulses[1..], pulsesToBinaryMapping)
      # binary is now something like: '01011100000000010001'
      # now we extract the data from that string

      return result = {
        bits: binary
        bytes: helper.binaryToOctets(binary, 32)
        id:    helper.binaryToNumber(binary, 0, 16)
        unit:  helper.binaryToNumber(binary, 30, 33)
        all:   helper.binaryToBoolean(binary, 14)
        state: helper.binaryToBoolean(binary, 15) or true
      }
    encodeMessage: (message) ->
      rfstring = '000011101000001100001111100001000'
      rfstring = helper.map(rfstring, binaryToPulse)
      return "0#{rfstring}2"
  }
