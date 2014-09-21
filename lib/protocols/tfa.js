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
    pulseLengths: [506, 625, 2013, 7728],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: 12,
        temperature: 23.6,
        humidity: 67
      };
    }
  };
};
