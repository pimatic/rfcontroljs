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
      var all, binary, result, state, unit, unitCode;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      unitCode = helper.binaryToNumberLSBMSB(binary, 21, 23);
      state = helper.binaryToBoolean(binary, 20);
      all = false;
      unit = ((function() {
        switch (unitCode) {
          case 7:
            return 1;
          case 6:
            return 2;
          case 5:
            return 3;
          case 3:
            return 4;
          default:
            all = true;
            state = !state;
            return 0;
        }
      })());
      return result = {
        id: helper.binaryToNumber(binary, 0, 19),
        unit: unit,
        state: state,
        all: all
      };
    },
    encodeMessage: function(message) {
      var id, rfstring, state, unit, unitCode;
      id = helper.numberToBinary(message.id, 20);
      if (message.all) {
        unitCode = 0;
        state = !message.state;
      } else {
        unitCode = ((function() {
          switch (message.unit) {
            case 1:
              return 7;
            case 2:
              return 6;
            case 3:
              return 5;
            case 4:
              return 3;
          }
        })());
        state = message.state;
      }
      state = (state ? '1' : '0');
      unit = helper.numberToBinaryLSBMSB(unitCode, 3);
      rfstring = "" + id + state + unit;
      rfstring = helper.map(rfstring, binaryToPulse);
      return "" + rfstring + "02";
    }
  };
};
