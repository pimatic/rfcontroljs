module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '02': ''
  };
  binaryToPulse = {
    '1': '10',
    '0': '01'
  };
  return protocolInfo = {
    name: 'switch15',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      state: {
        type: "boolean"
      },
      all: {
        type: "boolean"
      }
    },
    brands: ["Daycom Switches"],
    pulseLengths: [300, 914, 9624],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var all, binary, result, state, unit;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      unit = 8 - helper.binaryToNumberLSBMSB(binary, 21, 23);
      state = helper.binaryToBoolean(binary, 20);
      all = false;
      if (unit === 8) {
        unit = 0;
        all = true;
        state = !state;
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 19),
        unit: unit,
        state: state,
        all: all
      };
    },
    encodeMessage: function(message) {
      var id, rfstring, state, unit;
      id = helper.numberToBinary(message.id, 20);
      state = (message.state ? '1' : '0');
      unit = helper.numberToBinaryLSBMSB(8 - message.unit, 3);
      if (message.all != null) {
        if (message.all === true) {
          unit = helper.numberToBinaryLSBMSB(0, 3);
          state = (message.state ? '0' : '1');
        }
      }
      rfstring = "" + id + state + unit;
      rfstring = helper.map(rfstring, binaryToPulse);
      return "" + rfstring + "02";
    }
  };
};
