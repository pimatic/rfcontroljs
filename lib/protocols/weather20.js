module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': "0",
    '02': "0",
    '03': "1",
    '04': ""
  };
  return protocolInfo = {
    name: "weather20",
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
    brands: ["Freetec PT-250 variant"],
    pulseLengths: [560, 972, 1904, 3812, 8556],
    pulseCount: 76,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      console.log(binary);
      return result = {
        id: helper.binaryToNumber(binary, 0, 11),
        channel: helper.binaryToNumber(binary, 14, 15) + 1,
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10,
        lowBattery: helper.binaryToBoolean(binary, 12)
      };
    }
  };
};
