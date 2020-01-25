module.exports = (helper) ->
  # as mapping overlap we need
  # maintain the order of mappings,
  # as map function applies first match
  pulsesToBinaryMapping = [
    {'12222222': '' } #header
    {'12': '0' } #binary 0
    {'22': '1' } #binary 0
    {'20': '1' } #binary 1
    {'21': '1' } #binary 1
    {'13': '' }  #footer
    {'23': '' }  #footer
  ]
  return protocolInfo = {
    name: 'weather21'
    type: 'weather'
    values:
      temperature:
        type: "number"
      humidity:
        type: "number"
      channel:
        type: "number"
      id:
        type: "number"
      lowBattery:
        type: "boolean"
    brands: ["Auriol HG02832"]
    pulseLengths: [196, 288, 628, 61284]
    pulseCount: 88
    decodePulses: (pulses) ->
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      console.log pulses, "\n", binary
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      #   0-----7     8  14-15   16--------27   28----35
      # | 10001101 | 11 | 000100001001 | 00111101 |
      # |    ID    | BT | Temp.        | Humid.   |
      lowBattery = not helper.binaryToBoolean(binary, 8)
      flags = helper.binaryToNumberMSBLSB(binary, 16, 19)
      return result = {
        id: helper.binaryToNumberMSBLSB(binary, 0, 7)
        channel: helper.binaryToNumberMSBLSB(binary, 18, 19) + 1
        temperature: helper.binaryToSignedNumberMSBLSB(binary, 20, 31) / 10
        humidity: helper.binaryToNumberMSBLSB(binary, 8, 15)
        lowBattery: helper.binaryToBoolean(binary, 8)
      }
  }
