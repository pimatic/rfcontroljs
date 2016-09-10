module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '11': '0',
    '01': '1',
    '02': '',
    '12': ''
  };
  return protocolInfo = {
    name: 'weather17',
    type: 'weather',
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      temperature: {
        type: "number"
      },
      humidity: {
        type: "number"
      }
    },
    brands: ["TFA 30.3125"],
    pulseLengths: [444, 1160, 28580],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, p0, p1, p2, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      p0 = helper.binaryToNumber(binary, 20, 23);
      p1 = helper.binaryToNumber(binary, 24, 27);
      p2 = helper.binaryToNumber(binary, 28, 31);
      result = {
        id: helper.binaryToNumber(binary, 12, 18),
        channel: helper.binaryToNumber(binary, 8, 10)
      };
      if (result.channel === 0) {
        result.temperature = ((p0 - 5) * 10) + p1 + (p2 * 0.1);
      } else {
        result.humidity = p0 * 10 + p1;
      }
      return result;
    }
  };
};
