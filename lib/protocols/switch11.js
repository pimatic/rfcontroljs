module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '1',
    '10': '0',
    '02': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '10'
  };
  return protocolInfo = {
    name: 'switch11',
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
    brands: ["McPower"],
    pulseLengths: [566, 1267, 6992],
    pulseCount: 66,
    decodePulses: function(pulses) {
      var binary, result, state, unit;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      unit = helper.binaryToNumber(binary, 3, 3);
      if (unit === 1) {
        state = helper.binaryToBoolean(binary, 4);
      } else {
        state = helper.binaryToBoolean(binary, 5);
      }
      return result = {
        id: helper.binaryToNumber(binary, 6, 21),
        unit: unit,
        state: state
      };
    },
    encodeMessage: function(message) {
      var id, inv_state, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 1), binaryToPulse);
      inv_state = !state;
      if (unit === 1) {
        return "011010" + unit + state + inv_state + id + "02";
      } else {
        return "011010" + unit + inv_state + state + id + "02";
      }
    }
  };
};
