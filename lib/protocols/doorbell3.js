module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '10': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'doorbell3',
    type: 'switch',
    values: {
      id: {
        type: 'number'
      },
      unit: {
        type: 'number'
      }
    },
    brands: ['WP515S'],
    pulseLengths: [295, 590, 9864],
    pulseCount: 26,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 1, 4),
        unit: helper.binaryToNumber(binary, 5, 12)
      };
    },
    encodeMessage: function(message) {
      var id, unit;
      id = helper.map(helper.numberToBinary(message.id, 4), binaryToPulse);
      unit = helper.map(helper.numberToBinary(message.unit, 8), binaryToPulse);
      return "0" + id + unit + "2";
    }
  };
};
