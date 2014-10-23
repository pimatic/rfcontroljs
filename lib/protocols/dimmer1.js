module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '03': '',
    '0200': '1',
    '0002': '0',
    '14': ''
  };
  binaryToPulse = {
    '1': '0200',
    '0': '0002'
  };
  return protocolInfo = {
    name: 'dimmer1',
    type: 'dimmer',
    values: {
      id: {
        type: "binary"
      },
      all: {
        type: "boolean"
      },
      state: {
        type: "boolean"
      },
      unit: {
        type: "number"
      },
      dimlevel: {
        type: "number"
      }
    },
    brands: ["CoCo Technologies", "D-IO (Chacon)", "Intertechno", "KlikAanKlikUit", "Nexa"],
    pulseLengths: [255, 750, 1390, 2900, 11350],
    pulseCount: 148,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 25),
        all: helper.binaryToBoolean(binary, 26),
        state: helper.binaryToBoolean(binary, 27),
        unit: helper.binaryToNumber(binary, 28, 31),
        dimlevel: helper.binaryToNumber(binary, 32, 35)
      };
    },
    encodeMessage: function(message) {
      var all, dimlevel, id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse);
      all = (message.all ? binaryToPulse['1'] : binaryToPulse['0']);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse);
      dimlevel = helper.map(helper.numberToBinary(message.level, 4), binaryToPulse);
      return "03" + id + all + state + unit + dimlevel + "14";
    }
  };
};
