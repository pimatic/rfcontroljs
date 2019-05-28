# weather20 has been derived from weather15 as the the protocol of the Freetech PT-250 pool thermometer
# sensor appears to have changed with newer makes.
module.exports = (helper) ->
  pulsesToBinaryMapping =
    '01': "0"
    '02': "0"
    '03': "1"
    '04': ""
  return protocolInfo = {
    name: "weather20"
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
    brands: ["Freetec PT-250 variant"]
    pulseLengths: [560, 972, 1904, 3812, 8556]
    pulseCount: 76
    decodePulses: (pulses) ->
      # Pulse like: 0302020302020202030202020302020202020202030302020202030202020202020202020104
      # Bits like:
      # 1001 0000 1000 1000 0000 1100 0010 0000 0000 004
      # 1001 1001 0000 0100 0000 1010 0000 0011 1010 103
      # IIII IIII IIII BxCC TTTT TTTT TTTT HHHH HHHH
      # I: 8 bit ID
      # B: 0 full battery; 1 low battery
      # C: 2bit Channel: 00 -> Ch. 1; 01 -> Ch. 2; 10 -> Ch. 3 (channel 1 in this case)
      # T: 12 bit Temperature : 0000 1001 0001 -> 145 -> 14.5 (correct)
      # H: 8bit     73% (1001 001 = 73)
      binary = helper.map(pulses, pulsesToBinaryMapping)
      return result = {
        id: helper.binaryToNumber(binary, 0, 11)
        channel: helper.binaryToNumber(binary, 14, 15) + 1
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10
        lowBattery: helper.binaryToBoolean(binary, 12)
      }
  }
