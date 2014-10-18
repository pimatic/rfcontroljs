module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '1111111104': '' #header
    '02': '0' #binary 0
    '03': '1' #binary 1
    '05': '' #footer
  }
  return protocolInfo = {
    name: 'weather4'
    type: 'weather'
    values:
      id:
        type: "number"
      channel:
        type: "number"
      temperature:
        type: "number"
      humidity:
        type: "number"
      battery:
        type: "number"
    brands: ["Auriol"]
    pulseLengths:  [ 526, 990, 1903, 4130, 7828, 16076 ]
    pulseCount: 92
    decodePulses: (pulses) ->
      # pulses could be:
      # '11111111040203020202020202030202020203020302030203030303020303020303020202020302020202020305'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '0110001100000000011000011101011100110001'
      # based on this example : T18,8 H71 :1110111001010101011000011000011100010001
      # 11101110-0101-0101-011000011000-0111-0001-0001
      # 11101110 : Station ID (random after restart)
      # 0101 : Check Sum
      # 0101 : Batterie 0000=full(3V) 0100=2,6V
      # 0100 0000 0110 : temperature is sent by the sensor in °F (and not °C)
      # 0111-0001 : humidity first col is tenner, second col is one (einer) { 0111=7  0001=1  }= 71%H
      # 0001 : Channel (0001 = 1, xxxx = ?, xxxx = ?)
      # the lowest value that the protocol support is 90°F (000000000000).
      # In our example it give us 0110 0001 1000
      # which is 1560 in decimal
      # So the rule is 1560/10 - 90 = 66 °F (18,8 °C) (this rule works fine for all temp
      # positive/negative)
      t0 = helper.binaryToNumber(binary, 16, 27)
      temperature = Math.round((t0 * 10 - 12200) / 18 ) / 10

      h0 = helper.binaryToNumber(binary, 28, 31)
      h1 = helper.binaryToNumber(binary, 32, 35)
      humidity = h0 * 10 + h1
      battery = 3 - (helper.binaryToNumber(binary, 12, 15)/10)
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 36, 39),
        temperature: temperature
        humidity: humidity
        battery: battery
  }
}
