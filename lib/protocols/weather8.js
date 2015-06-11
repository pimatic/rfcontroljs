module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather8',
    type: 'weather',
    values: {
      temperature: {
        type: "number"
      },
      humidity: {
        type: "number"
      },
      id: {
        type: "number"
      }
    },
    brands: [],
    pulseLengths: [200, 1000, 2000, 8000],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        temperature: helper.binaryToSignedNumber(binary, 24, 35) / 10.0,
        humidity: helper.binaryToNumber(binary, 16, 23)
      };
    }
  };
};
