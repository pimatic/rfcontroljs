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
      }
    },
    models: [],
    pulseLengths: [456, 1990, 3940, 9236],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        temperature: helper.binaryToNumber(binary, 18, 27) / 10,
        humidity: helper.binaryToNumber(binary, 28, 35)
      };
    }
  };
};
