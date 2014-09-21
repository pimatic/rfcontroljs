module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'tfa',
    type: 'weather',
    values: {
      id: {
        type: "number"
      },
      temperature: {
        type: "number"
      },
      humidity: {
        type: "number"
      }
    },
    models: ["tfa"],
    pulseLengths: [508, 2012, 3908, 7726],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 2, 9),
        temperature: Math.round(((((helper.binaryToNumber(binary, 22, 25) * 256) + (helper.binaryToNumber(binary, 18, 21) * 16) + (helper.binaryToNumber(binary, 14, 17))) * 10) - 12200) / 18) / 10,
        humidity: helper.binaryToNumber(binary, 26, 29) + helper.binaryToNumber(binary, 30, 33) * 16
      };
    }
  };
};
