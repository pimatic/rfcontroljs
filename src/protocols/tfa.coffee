module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '1' #binary 0
    '02': '0' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'tfa'
    type: 'weather'
    values:
      id:
        type: "number"
      temperature:
        type: "number"
      humidity:
        type: "number"
    models: ["tfa"]
    pulseLengths: [506, 625, 2013, 7728]
    pulseCount: 88
    decodePulses: (pulses) ->
      # pulses is something like: '0202010101010201010202020102010102020201010202010102020201010201020202010202020101010303'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '001111011000101100011001100011010001000111'
      console.log binary
      # now we extract the temperature and humidity from that string
      # | 01011101000000010 | 00011100111 | 00100010 |
      # | ?                 | Temp.       | Humid.   |
      return result = {
        id: helper.binaryToNumber(binary, 2, 9),
        temperature: Math.round((((((((helper.binaryToNumber(binary, 22, 25)*256) + (helper.binaryToNumber(binary, 18, 21)*16) + (helper.binaryToNumber(binary, 14, 17)))*10) - 9000) - 3200) * (5/9)) /100) *10)/10,
        humidity: helper.binaryToNumber(binary, 26,29) + helper.binaryToNumber(binary, 30, 33)*16
      }
  }
