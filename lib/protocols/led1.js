module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '02': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '10'
  };
  return protocolInfo = {
    name: 'led1',
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
      }
    },
    brands: ["LED Stripe RF Dimmer (no name)"],
    pulseLengths: [348, 1051, 10864],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 20),
        unit: helper.binaryToNumber(binary, 21, 23),
        state: true
      };
    },
    encodeMessage: function(message) {
      var id, unit;
      if (message.state === false) {
        return "0";
      }
      id = helper.map(helper.numberToBinary(message.id, 21), binaryToPulse);
      unit = helper.map(helper.numberToBinary(message.unit, 3), binaryToPulse);
      return "" + id + unit + "02";
    }
  };
};
