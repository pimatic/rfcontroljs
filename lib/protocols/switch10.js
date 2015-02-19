module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '12': '1',
    '02': '0',
    '03': ''
  };
  binaryToPulse = {
    '1': '12',
    '0': '02'
  };
  return protocolInfo = {
    name: 'switch10',
    type: 'switch',
    values: {
      id: {
        type: "binary"
      },
      state: {
        type: "boolean"
      },
      unit: {
        type: "number"
      }
    },
    brands: ["Europe RS-200"],
    pulseLengths: [562, 1313, 3234, 52149],
    pulseCount: 44,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 9),
        unit: helper.binaryToNumber(binary, 20, 21),
        state: helper.binaryToBoolean(binary, 19)
      };
    },
    encodeMessage: function(message) {
      var id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 10), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 2), binaryToPulse);
      return "" + id + "011111111" + state + unit + "03";
    }
  };
};
