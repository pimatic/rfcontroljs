module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': "0",
    '02': "1",
    '03': ""
  };
  return protocolInfo = {
    name: "weather12",
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
    brands: ["Globaltronics GT-WT-01"],
    pulseLengths: [496, 2048, 4068, 8960],
    pulseCount: 76,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 10, 11) + 1,
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10,
        humidity: helper.binaryToNumber(binary, 24, 30),
        lowBattery: helper.binaryToBoolean(binary, 8)
      };
    }
  };
};
