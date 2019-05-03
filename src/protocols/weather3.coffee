module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather3'
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
    brands: ["TFA", "Conrad Electronic"]
    pulseLengths: [508, 2012, 3908, 7726]
    pulseCount: 86
    decodePulses: (pulses) ->
      # pulses could be:
      # '02020101010102010102020201020101020202010102020101020202010102010202020102020201010103'
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
      # Again you have to swap (321) the column order, in our example it give us 0110 0000 0100
      # which is 1540 in decimal
      # So the rule is 1540/10 - 90 = 64 °F (17.78 °C) (this rule works fine for all temp
      # positive/negative)
      t0 = helper.binaryToNumber(binary, 22, 25)
      t1 = helper.binaryToNumber(binary, 18, 21)
      t2 = helper.binaryToNumber(binary, 14, 17)
      temperature = Math.round(((t0 * 256 + t1 * 16 + t2) * 10 - 12200) / 18 ) / 10
      # 0000 0100 : humidity swap the 2 col and it give the bin value of the HUM (ie 100 000 = 64)
      h0 = helper.binaryToNumber(binary, 30, 33)
      h1 = helper.binaryToNumber(binary, 26, 29)
      humidity = h0 * 16 + h1
      # 0000 : battery ?? if > 0100 then BAT is failing ??
      # 0011 : cksum ?? don't know/care
      return result = {
        id: helper.binaryToNumber(binary, 2, 9),
        channel: helper.binaryToNumber(binary, 12, 13) + 1,
        temperature: temperature
        humidity: humidity
      }
  }
