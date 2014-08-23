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
    name: 'switch4',
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
    brands: ["Cogex", "KlikAanKlikUit", "Intertechno", "Düwi Terminal"],
    pulseLengths: [295, 1180, 11210],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary, 0, 4),
        id: helper.binaryToNumber(binary, 5, 9),
        state: helper.binaryToBoolean(binary, 11)
      };
    },
    encodeMessage: function(message) {
      var fixed, id, state, unit;
      unit = helper.map(helper.numberToBinary(message.unit, 5), binaryToPulse);
      id = helper.map(helper.numberToBinary(message.id, 5), binaryToPulse);
      fixed = binaryToPulse['0'];
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      return "" + unit + id + fixed + state;
    }
  };
};
