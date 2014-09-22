module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
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
    pulseLengths: [508, 2012, 3908, 7726]
    pulseCount: 88
    decodePulses: (pulses) ->
      # pulses could be: '0202010101010201010202020102010102020201010202010102020201010201020202010202020101010303'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '001111011000101100011001100011010001000111'
      # based on this example : T17.8 H64 :0000001111001001000000011000000100000000117582
      # 00: don't know/care
      # 00001111 : Station ID
      # 00 : don't know/care
      # 10 : channel (00 means Ch 1, 01 Ch 2, 10 Ch3)
      # 0100 0000 0110 : temperature is sent by the sensor in °F (and not °C)
      # the lowest value that the protocol support is 90°F (000000000000).
      # Again you have to swap (321) the column order, in our example it give us 0110 0000 0100 which is 1540 in decimal
      # So the rule is 1540/10 - 90 = 64 °F (17.78 °C) (this rule works fine for all temp positive/negative)
      # 0000 0100 : humidity swap the 2 col and it give the bin value of the HUM (ie 100 000 = 64)
      # 0000 : battery ?? if > 0100 then BAT is failing ??
      # 0011 : cksum ?? don't know/care
      return result = {
        id: helper.binaryToNumber(binary, 2, 9),
        temperature: Math.round((((helper.binaryToNumber(binary, 22, 25)*256 + helper.binaryToNumber(binary, 18, 21)*16 + helper.binaryToNumber(binary, 14, 17))*10) - 12200) /18)/10,
        humidity: helper.binaryToNumber(binary, 26,29) + helper.binaryToNumber(binary, 30, 33)*16
      }
  }
