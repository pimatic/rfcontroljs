module.exports = (helper) ->
# mapping for decoding
  pulsesToBinaryMapping = {
    '10': '1'   #binary 1
    '01': '0'   #binary 0
    '02': ''    #footer
    '03': ''    #footer
  }
  # same for send
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'pir6'
    type: 'pir'
    values:
      id:
        type: "number"
      presence:
        type: "boolean"
    brands: ["Zanbo (ZABC86-1)", "Unknown (OSW-1-3 and OTW-1-3)"]
    pulseLengths: [288, 864, 8964]
    pulseCounts: [50]
    decodePulses: (pulses) ->
      binary = helper.map(pulses, pulsesToBinaryMapping)
      console.log "######", binary, helper.binaryToNumber(binary, 2, 24)
      # Pulses like: '001100001110100011000011'
      # Translate to the following sequence
      # 0011 0000 1110 1000 1100 0011
      # xxII IIII IIII IIII IIII IIII
      # I: 24 bit ID (unsigned, MSB)
      # x: ignored
      return result = {
        id: helper.binaryToNumber(binary, 2, 24)
        presence: true
      }
  }
