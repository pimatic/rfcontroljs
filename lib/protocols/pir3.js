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
    name: 'pir3',
    type: 'pir',
    values: {
      unit: {
        type: "binary"
      },
      presence: {
        type: "boolean"
      }
    },
    brands: [],
    pulseLengths: [496, 1471, 6924],
    pulseCount: 66,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: binary,
        presence: true
      };
    }
  };
};
