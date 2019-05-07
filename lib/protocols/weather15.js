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
    brands: ["Globaltronics GT-WT-01 variant", "Freetec PT-250"],
    pulseLengths: [496, 2048, 4068, 8960],
    pulseCount: 76,
    decodePulses: function(pulses) {
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
