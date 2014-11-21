module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '10',
    '1': '01'
  };
  return protocolInfo = {
    name: 'pir2',
    type: 'pir',
    values: {
      unit: {
        type: "number"
      },
      id: {
        type: "number"
      },
      presence: {
        type: "boolean"
      }
    },
    brands: [],
    pulseLengths: [451, 1402, 14356],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary, 0, 4),
        id: helper.binaryToNumber(binary, 5, 9),
        presence: true
      };
    }
  };
};
