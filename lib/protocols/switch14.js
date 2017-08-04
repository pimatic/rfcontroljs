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
    name: 'switch14',
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
    brands: ["UNITEC"],
    pulseLengths: [209, 623, 6288],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 19),
        unit: 4 - helper.binaryToNumberLSBMSB(binary, 20, 21),
        all: !helper.binaryToBoolean(binary, 22),
        state: helper.binaryToBoolean(binary, 23)
      };
    },
    encodeMessage: function(message) {
      var all, id, rfstring, state, unit;
      id = helper.numberToBinary(message.id, 20);
      state = (message.state ? '1' : '0');
      all = '1';
      if (message.all != null) {
        if (message.all === true) {
          all = '0';
        }
      }
      unit = helper.numberToBinaryLSBMSB(4 - message.unit, 2);
      rfstring = "" + id + unit + all + state;
      rfstring = helper.map(rfstring, binaryToPulse);
      return rfstring + "02";
    }
  };
};
