module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '30': '',
    '01': '0',
    '02': '1',
    '04': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '02'
  };
  return protocolInfo = {
    name: 'alarm2',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["FA21RF"],
    pulseLengths: [805, 1377, 2710, 8104, 22564],
    pulseCount: 52,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 23),
        state: true
      };
    },
    encodeMessage: function(message) {
      var unit;
      if (message.state === false) {
        return "0";
      }
      unit = helper.map(helper.numberToBinary(message.id, 24), binaryToPulse);
      return "30" + unit + "0430" + unit + "0430" + unit + "04";
    }
  };
};
