module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '',
    '01': '1',
    '10': '0',
    '03': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '10'
  };
  return protocolInfo = {
    name: 'switch18',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Otio", "Advisen"],
    pulseLengths: [600, 1200, 3500, 7000],
    pulseCount: 68,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 4, 31),
        state: helper.binaryToBoolean(binary, 2)
      };
    },
    encodeMessage: function(message) {
      var id, state;
      id = helper.map(helper.numberToBinary(message.id, 28), binaryToPulse);
      state = (message.state ? '1001' : '0110');
      return "1001" + state + id + "03";
    }
  };
};
