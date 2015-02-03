module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '',
    '0100': '1',
    '0001': '0',
    '0000': 'N',
    '03': ''
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
        type: "number",
        min: 0,
        max: 15
      }
    },
    brands: ["CoCo Technologies", "D-IO (Chacon)", "Intertechno", "KlikAanKlikUit", "Nexa"],
    pulseLengths: [260, 1300, 2700, 10400],
    pulseCount: 148,
    decodePulses: function(pulses) {
      var binary, result, state;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      if (binary[27] !== "N") {
        state = helper.binaryToBoolean(binary, 27);
      }
      result = {
        id: helper.binaryToNumber(binary, 0, 25),
        all: helper.binaryToBoolean(binary, 26),
        unit: helper.binaryToNumber(binary, 28, 31),
        dimlevel: helper.binaryToNumber(binary, 32, 35),
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
      dimlevel = helper.map(helper.numberToBinary(message.dimlevel, 4), binaryToPulse);
      return "02" + id + all + state + unit + dimlevel + "03";
    }
  };
};
