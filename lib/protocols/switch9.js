module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '1',
    '10': '0',
    '12': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '10'
  };
  return protocolInfo = {
    name: 'switch9',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      },
      unit: {
        type: "number"
      }
    },
    brands: ["DRU Heaters"],
    pulseLengths: [300, 600, 23000],
    pulseCount: 46,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 11),
        unit: helper.binaryToNumber(binary, 12, 19),
        state: helper.binaryToBoolean(binary, 20)
      };
    },
    encodeMessage: function(message) {
      var id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 12), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 8), binaryToPulse);
      return "" + id + unit + state + "1012";
    }
  };
};
