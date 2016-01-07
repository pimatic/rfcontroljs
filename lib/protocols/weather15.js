module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': "0",
    '02': "1",
    '03': ""
  };
  return protocolInfo = {
    name: "weather15",
    type: "weather",
    values: {
      temperature: {
        type: "number"
      },
      humidity: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      id: {
        type: "number"
      },
      lowBattery: {
        type: "boolean"
      }
    },
    brands: ["Globaltronics GT-WT-01 variant"],
    pulseLengths: [496, 2048, 4068, 8960],
    pulseCount: 76,
    decodePulses: function(pulses) {

      /*
      Pulse like: 0201010202010202010101010101010101020202010201010202010202020102020201010103
      
      Bits like:
      1001 1001 0000 0100 0000 1010 0000 0011 1010 103
      IIII IIII IIII BxCC TTTT TTTT TTTT HHHH HHHH
      I: 8 bit ID
      B: 0 full battery; 1 low battery
      C: 2bit Channel: 00 -> Ch. 1; 01 -> Ch. 2; 10 -> Ch. 3 (channel 1 in this case)
      T: 12 bit Temperature : 0000 1001 0001 -> 145 -> 14.5 (correct)
      H: 7bit     73% (1001 001 = 73)
       */
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 11),
        channel: helper.binaryToNumber(binary, 14, 15) + 1,
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10,
        humidity: helper.binaryToNumber(binary, 28, 35),
        lowBattery: helper.binaryToBoolean(binary, 12)
      };
    }
  };
};
