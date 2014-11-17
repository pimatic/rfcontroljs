module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0110': '0',
    '1010': '0',
    '0101': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '0101'
  };
  return protocolInfo = {
    name: 'switch7',
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
    brands: ["eHome"],
    pulseLengths: [307, 944, 9712],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumberLSBMSB(binary, 1, 3),
        id: helper.binaryToNumberLSBMSB(binary, 4, 6),
        state: helper.binaryToBoolean(binary, 0)
      };
    },
    encodeMessage: function(message) {
      var id, state, unit;
      unit = helper.map(helper.numberToBinaryLSBMSB(message.unit, 3), binaryToPulse);
      id = helper.map(helper.numberToBinaryLSBMSB(message.id, 3), binaryToPulse);
      state = (message.state ? '0101' : '1010');
      return "" + state + unit + id + "0110011001100110011002";
    }
  };
};
