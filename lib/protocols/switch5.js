module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '10',
    '1': '01'
  };
  return protocolInfo = {
    name: 'switch5',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      all: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Eurodomest"],
    pulseLengths: [295, 886, 9626],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var all, binary, id, result, state, unit, unitCode;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      id = helper.binaryToNumber(binary, 0, 19);
      unitCode = helper.binaryToNumber(binary, 20, 22);
      state = !helper.binaryToBoolean(binary, 23);
      all = false;
      unit = ((function() {
        switch (unitCode) {
          case 0:
            return 1;
          case 1:
            return 2;
          case 2:
            return 3;
          case 4:
            return 4;
          default:
            all = true;
            return 0;
        }
      })());
      return result = {
        id: id,
        unit: unit,
        all: all,
        state: state
      };
    },
    encodeMessage: function(message) {
      var id, inverseState, unitCode;
      id = helper.map(helper.numberToBinary(message.id, 20), binaryToPulse);
      unitCode = ((function() {
        switch (message.unit) {
          case 1:
            return 0;
          case 2:
            return 1;
          case 3:
            return 2;
          case 4:
            return 4;
        }
      })());
      unitCode = helper.map(helper.numberToBinary(unitCode, 3), binaryToPulse);
      inverseState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + id + unitCode + inverseState + "02";
    }
  };
};
