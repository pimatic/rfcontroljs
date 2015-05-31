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
    name: 'switch18',
    type: 'switch',
    values: {
      header: {
        type: "number"
      },
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["MBO International Electronic GmbH"],
    pulseLengths: [132, 400, 4144],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        header: helper.binaryToNumberLSBMSB(binary, 0, 2),
        unitCode: helper.binaryToNumberLSBMSB(binary, 3, 6),
        state: !helper.binaryToBoolean(binary, 7)
      };
    },
    encodeMessage: function(message) {
      var header, inverseState, unitCode, zero;
      header = helper.map(helper.numberToBinaryLSBMSB(message.header, 3), binaryToPulse);
      unitCode = helper.map(helper.numberToBinaryLSBMSB(message.unitCode, 4), binaryToPulse);
      inverseState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      zero = binaryToPulse['0'];
      return "" + header + unitCode + inverseState + zero + zero + inverseState + zero + "02";
    }
  };
};
