module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '1',
    '10': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '10',
    '1': '01'
  };
  return protocolInfo = {
    name: 'doorbell2',
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
    brands: ["LIFETEC-MD13187"],
    pulseLengths: [491, 1491, 19270],
    pulseCount: 48,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary, 0, 11),
        id: helper.binaryToNumber(binary, 12, 22),
        presence: true
      };
    },
    encodeMessage: function(message) {
      var id, unit;
      unit = helper.map(helper.numberToBinary(message.unit, 12), binaryToPulse);
      id = helper.map(helper.numberToBinary(message.id, 11), binaryToPulse);
      return "" + unit + id + "02";
    }
  };
};
