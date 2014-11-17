module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10100': '0',
    '01010': '1',
    '110011001100110011002': ''
  };
  binaryToPulse = {
    '0': '10100',
    '1': '01010'
  };
  return protocolInfo = {
    name: 'switch7',
    type: 'switch',
    values: {
      unit: {
        type: "number"
      },
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["eHome"],
    pulseLengths: [307, 944, 9712],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary, 0, 4),
        id: helper.binaryToNumber(binary, 5, 9),
        state: !helper.binaryToBoolean(binary, 11)
      };
    },
    encodeMessage: function(message) {
      var fixed, id, invertedState, unit;
      unit = helper.map(helper.numberToBinary(message.unit, 5), binaryToPulse);
      id = helper.map(helper.numberToBinary(message.id, 5), binaryToPulse);
      fixed = binaryToPulse['0'];
      invertedState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + unit + id + fixed + invertedState + "02";
    }
  };
};
