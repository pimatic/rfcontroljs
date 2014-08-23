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
    name: 'switch3',
    type: 'switch',
    values: {
      houseCode: {
        type: "number"
      },
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Brennenstuhl Comfort", "Elro Home Control"],
    pulseLengths: [306, 957, 9808],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        houseCode: helper.binaryToNumber(binary, 0, 4),
        unitCode: helper.binaryToNumber(binary, 5, 9),
        state: helper.binaryToBoolean(binary, 11)
      };
    },
    encodeMessage: function(message) {
      var houseCode, inverseState, state, unitCode;
      houseCode = helper.map(helper.numberToBinary(message.houseCode, 5), binaryToPulse);
      unitCode = helper.map(helper.numberToBinary(message.unitCode, 5), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      inverseState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + houseCode + unitCode + inverseState + state;
    }
  };
};
