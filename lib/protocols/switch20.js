module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0101': '1',
    '0110': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '0101'
  };
  return protocolInfo = {
    name: 'switch20',
    type: 'switch',
    values: {
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["MBO International Electronic GmbH"],
    pulseLengths: [128, 400, 4152],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unitCode: helper.binaryToNumberLSBMSB(binary, 3, 6),
        state: !helper.binaryToBoolean(binary, 7)
      };
    },
    encodeMessage: function(message) {
      var header, inverseState, one, unitCode, zero;
      zero = binaryToPulse['0'];
      one = binaryToPulse['1'];
      header = "" + zero + zero + one;
      unitCode = helper.map(helper.numberToBinaryLSBMSB(message.unitCode, 4), binaryToPulse);
      inverseState = (message.state ? zero : one);
      return "" + header + unitCode + inverseState + zero + zero + inverseState + zero + "02";
    }
  };
};
