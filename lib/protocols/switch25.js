module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'switch25',
    type: 'switch',
    values: {
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Lidl 0655B"],
    pulseLengths: [350, 880, 10970],
    pulseCount: 66,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unitCode: helper.binaryToNumber(binary, 25, 28),
        state: helper.binaryToBoolean(binary, 29)
      };
    },
    encodeMessage: function(message) {
      var inverseState, prefix, state, unitCode;
      prefix = "10101010101010101010101010101010010101010101010101";
      unitCode = helper.map(helper.numberToBinary(message.unitCode, 4), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      inverseState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + prefix + unitCode + state + inverseState + "1002";
    }
  };
};
