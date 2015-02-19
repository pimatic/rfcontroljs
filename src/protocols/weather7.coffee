module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather7'
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
      battery:
        type: "string"
    brands: ["Auriol"]
    pulseLengths: [456, 1990, 3940, 9236]
    pulseCount: 66
    decodePulses: (pulses) ->
      # pulses is something like: '01020102020201020101010101010102010101010202020101020202010102010101020103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      #   0-----7     8  14-15   16--------27   28----35
      # | 10001101 | 11 | 000100001001 | 00111101 |
      # |    ID    | BT | Temp.        | Humid.   |
      battery = helper.binaryToBoolean(binary, 8)
      if battery is true then battery = "Good"
      else battery = "Bad"
      return result = {
        id: helper.binaryToNumberMSBLSB(binary, 0, 7)
        channel: helper.binaryToNumberMSBLSB(binary, 10, 11)
        temperature: helper.binaryToSignedNumberMSBLSB(binary, 12, 23) / 10
        humidity: helper.binaryToNumberMSBLSB(binary, 24, 29)
        battery: battery
      }
  }
