module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '12': '1',
    '02': '0',
    '03': '',
    '13': ''
  };
  binaryToPulse = {
    '1': '12',
    '0': '02'
  };
  return protocolInfo = {
    name: 'switch12',
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
    brands: ["Europe RS-200"],
    pulseLengths: [562, 1313, 3234, 34888],
    pulseCount: 52,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 13),
        unit: 4 - helper.binaryToNumber(binary, 16, 17),
        state: helper.binaryToBoolean(binary, 19)
      };
    },
    encodeMessage: function(message) {
      var id, rfstring, state, state_inv, unit1;
      id = helper.numberToBinary(message.id, 14);
      state = (message.state ? '1' : '0');
      state_inv = (message.state ? '0' : '1');
      unit1 = helper.numberToBinary(4 - message.unit, 2);
      if (message.unit === 1) {
        rfstring = helper.map("" + id + state_inv + "1" + unit1 + "1" + state + "11" + state + state + "1", binaryToPulse);
      } else {
        rfstring = helper.map("" + id + state + "1" + unit1 + "1" + state + "11" + state_inv + state + "0", binaryToPulse);
      }
      if (message.unit === 2) {
        return "" + rfstring + "13";
      } else {
        return "" + rfstring + "03";
      }
    }
  };
};
