module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '',
    '0100': '1',
    '0001': '0',
    '0000': 'N',
    '13': ''
  };
  binaryToPulse = {
    '1': '0100',
    '0': '0001',
    'N': '0000'
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
    pulseLengths: [255, 1079, 2904, 11346],
    pulseCount: 148,
    decodePulses: function(pulses) {
      var binary, level, result, state;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      level = Math.round(helper.binaryToNumber(binary, 32, 35) * 6.666);
      if (binary[27] !== "N") {
        state = helper.binaryToBoolean(binary, 27);
      }
      result = {
        id: helper.binaryToNumber(binary, 0, 25),
        all: helper.binaryToBoolean(binary, 26),
        unit: helper.binaryToNumber(binary, 28, 31),
        dimlevel: level,
        state: state
      };
      return result;
    },
    encodeMessage: function(message) {
      var all, dimlevel, id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse);
      all = (message.all ? binaryToPulse['1'] : binaryToPulse['0']);
      if (message.state != null) {
        state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      } else {
        state = binaryToPulse['N'];
      }
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse);
      dimlevel = helper.map(helper.numberToBinary(Math.round(message.dimlevel / 6.666), 4), binaryToPulse);
      return "02" + id + all + state + unit + dimlevel + "13";
    }
  };
};
