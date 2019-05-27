module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0110': '0',
    '0101': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '0101'
  };
  return protocolInfo = {
    name: 'switch32',
    type: 'switch',
    values: {
      systemCode: {
        type: "number"
      },
      programCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Rising Sun RSL366", "Conrad RSL366", "PROmax"],
    pulseLengths: [440, 1300, 13488],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        systemCode: helper.binaryToBitPos(binary, 0, 3),
        programCode: helper.binaryToBitPos(binary, 4, 7),
        state: !helper.binaryToBoolean(binary, 11)
      };
    },
    encodeMessage: function(message) {
      var programCode, state, systemCode;
      systemCode = helper.map(helper.bitPosToBinary(message.systemCode, 4), binaryToPulse);
      programCode = helper.map(helper.bitPosToBinary(message.programCode, 4), binaryToPulse);
      state = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + systemCode + programCode + "011001100110" + state + "02";
    }
  };
};
