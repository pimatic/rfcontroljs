module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0': '0',
    '1': '1',
    '2': ''
  };
  binaryToPulse = {
    '0': '0',
    '1': '1'
  };
  return protocolInfo = {
    name: 'pir4',
    type: 'pir',
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      presence: {
        type: "boolean"
      }
    },
    brands: [],
    pulseLengths: [371, 1081, 5803],
    pulseCount: 36,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 15),
        unit: helper.binaryToNumber(binary, 16, 31),
        presence: true
      };
    }
  };
};
