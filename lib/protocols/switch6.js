module.exports = function(helper) {
  var binaryToPulse, binaryToPulse2, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0101': '1',
    '1010': '1',
    '0110': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '1010'
  };
  binaryToPulse2 = {
    '0': '0110',
    '1': '0101'
  };
  return protocolInfo = {
    name: 'switch6',
    type: 'switch',
    values: {
      systemcode: {
        type: "number"
      },
      programcode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Impuls"],
    pulseLengths: [150, 453, 4733],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        systemcode: helper.binaryToNumber(binary, 0, 4, 'LSB-MSB'),
        programcode: helper.binaryToNumber(binary, 5, 9, 'LSB-MSB'),
        state: helper.binaryToBoolean(binary, 11)
      };
    },
    encodeMessage: function(message) {
      var inverseState, programcode, state, systemcode;
      systemcode = helper.map(helper.numberToBinary(message.systemcode, 5, 'LSB-MSB'), binaryToPulse);
      programcode = helper.map(helper.numberToBinary(message.programcode, 5, 'LSB-MSB'), binaryToPulse2);
      inverseState = (message.state ? binaryToPulse2['0'] : binaryToPulse2['1']);
      state = (message.state ? binaryToPulse2['1'] : binaryToPulse2['0']);
      return "" + systemcode + programcode + inverseState + state + "02";
    }
  };
};
