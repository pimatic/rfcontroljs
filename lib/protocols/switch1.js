module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '',
    '0100': '1',
    '0001': '0',
    '03': ''
  };
  binaryToPulse = {
    '1': '0100',
    '0': '0001'
  };
  return protocolInfo = {
    name: 'switch1',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      all: {
        type: "boolean"
      },
      state: {
        type: "boolean"
      },
      unit: {
        type: "number"
      }
    },
    brands: ["CoCo Technologies", "D-IO (Chacon)", "Intertechno", "KlikAanKlikUit", "Nexa"],
    pulseLengths: [268, 1282, 2632, 10168],
    pulseCount: 132,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 25),
        all: helper.binaryToBoolean(binary, 26),
        state: helper.binaryToBoolean(binary, 27),
        unit: helper.binaryToNumber(binary, 28, 31)
      };
    },
    encodeMessage: function(message) {
      var all, id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse);
      all = (message.all ? binaryToPulse['1'] : binaryToPulse['0']);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse);
      return "02" + id + all + state + unit + "03";
    }
  };
};
