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
    name: 'switch12',
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
        unit: helper.binaryToNumber(binary, 12, 13),
        state: helper.binaryToBoolean(binary, 15)
      };
    },
    encodeMessage: function(message) {
      var id, rfstring, state, state_inv, unit1;
      id = helper.numberToBinary(message.id, 10);
      state = (message.state ? '1' : '0');
      state_inv = (message.state ? '0' : '1');
      unit1 = helper.numberToBinary(message.unit, 2);
      rfstring = helper.map("" + id + state + "1" + unit1 + "1" + state + "11" + state_inv + state + "0", binaryToPulse);
      return "" + rfstring + "03";
    }
  };
};
