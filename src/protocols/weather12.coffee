module.exports = (helper) ->
  pulsesToBinaryMapping =
    '01': "0"
    '02': "1"
    '03': ""
  return protocolInfo = {
    name: "weather12"
    type: "weather"
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
    brands: ["Globaltronics GT-WT-01"]
    pulseLengths: [496, 2048, 4068, 8960]
    pulseCount: 76
    decodePulses: (pulses) ->
      ###
Pulse like: 0201010202010202010101010101010101020202010201010202010202020102020201010103

Bits like:
0111 0001 1000 0000 1001 0001 1001 0011 0010 103
IIII IIII BxCC TTTT TTTT TTTT HHHH HHHx 
I: 8 bit ID
B: 0 full battery; 1 low battery 
C: 2bit Channel: 00 -> Ch. 1; 01 -> Ch. 2; 10 -> Ch. 3 (channel 1 in this case)
T: 12 bit Temperature : 0000 1001 0001 -> 145 -> 14.5 (correct)
H: 7bit     73% (1001 001 = 73)
      ###
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 7)
        lowBattery = binaryToNumber(binary, 8, 8) is 1
        channel: helper.binaryToNumber(binary, 10, 11) + 1
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10
        humidity: helper.binaryToNumber(binary, 24, 29)
        lowBattery: lowBattery
      }
  }
