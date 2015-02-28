module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather1',
    type: 'weather',
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
    brands: [],
    pulseLengths: [456, 1990, 3940, 9236],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, lowBattery, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      lowBattery = !helper.binaryToBoolean(binary, 12);
      return result = {
        id: helper.binaryToNumber(binary, 4, 11),
        channel: helper.binaryToNumber(binary, 14, 15) + 1,
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10,
        humidity: helper.binaryToNumber(binary, 28, 35),
        lowBattery: lowBattery
      };
    }
  };
};
