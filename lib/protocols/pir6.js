module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0101': '1',
    '1010': '1',
    '0110': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '1010'
  };

  binaryToPulse2 = {
    '0': '0110',
    '1': '0101'
  };


  return protocolInfo = {
    name: 'pir6',
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
    pulseLengths: [150, 453, 4733],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 4),
        unit: helper.binaryToNumber(binary, 5, 9),
        presence: true
      };
    }
  };
};
