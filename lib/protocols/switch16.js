module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '1',
    '00': '0',
    '01': '',
    '03': ''
  };
  binaryToPulse = {
    '1': '02',
    '0': '00'
  };
  return protocolInfo = {
    name: 'switch16',
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
    brands: ["Intertek 22541673 (z.B. Bauhaus)"],
    pulseLengths: [260, 2680, 1275, 10550],
    pulseCount: 132,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 56, 59),
        unit: helper.binaryToNumber(binary, 60, 63),
        state: helper.binaryToBoolean(binary, 54)
      };
    },
    encodeMessage: function(message) {
      var id, state, reverseState, unit;
      id = helper.map(helper.numberToBinary(message.id, 4), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      reverseState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse);
      return "01020002000200000200020002020002000200020002000002020000020200020002000200020002000200020000020002020000020002" + state + reverseState + id + unit + "03";
    }
  };
};
