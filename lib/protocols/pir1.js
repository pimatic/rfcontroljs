module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0110': '0',
    '0101': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '0101'
  };
  return protocolInfo = {
    name: 'pir1',
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
    pulseLengths: [358, 1095, 11244],
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
