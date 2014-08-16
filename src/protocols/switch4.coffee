module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0110': '0' #binary 0
    '0101': '1' #binary 1 
    '02': ''    #footer
  }
  return protocolInfo = {
    name: 'switch4'
    type: 'switch'
    values:
      unit:
        type: "number"
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["Cogex", "KlikAanKlikUit", "Intertechno", "Düwi Terminal"]
    pulseLengths: [ 295, 1180, 11210 ]
    pulseCount: 50
    parse: (pulses) ->
      # pulses is something like: '01010110010101100110011001100110010101100110011002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '10100 00010 00'
      # now we extract the temperature and humidity from that string
      # |    10100 | 00010 |      0 |    0 |
      # |     Unit |    ID |  fixed | State|
      return result = {
        unit: helper.binaryToNumber(binary, 0, 5)
        id: helper.binaryToNumber(binary, 6, 10)
        state: helper.binaryToBoolean(binary, 12)
      }
  }
