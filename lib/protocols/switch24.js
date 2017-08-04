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
    name: 'switch24',
    type: 'switch',
    values: {
      houseCode: {
        type: "number"
      },
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Power remote 1204380", "Steffen 1204380"],
    pulseLengths: [512, 1024, 6144],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, binaryInverted, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      binaryInverted = helper.map(binary, {
        '0': '1',
        '1': '0'
      });
      return result = {
        houseCode: helper.binaryToNumber(binaryInverted, 0, 4),
        unitCode: helper.binaryToNumber(binary, 19, 23),
        state: helper.binaryToBoolean(binary, 16)
      };
    },
    encodeMessage: function(message) {
      var houseCode, houseCodeBinary, houseCodeBinaryInverted, state, unitCode;
      houseCodeBinary = helper.numberToBinary(message.houseCode, 5);
      houseCodeBinaryInverted = helper.map(houseCodeBinary, {
        '0': '1',
        '1': '0'
      });
      houseCode = helper.map(houseCodeBinaryInverted, binaryToPulse);
      unitCode = helper.map(helper.numberToBinary(message.unitCode, 5), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      return houseCode + "0101011010100110010110" + state + "0101" + unitCode + "02";
    }
  };
};
