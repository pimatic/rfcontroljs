module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '32': '',
    '01': '0',
    '10': '1',
    '14': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'shutter1',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Nobily"],
    pulseLengths: [280, 736, 1532, 4752, 7796],
    pulseCounts: 168,
    decodePulses: function(pulses) {
      var binary, result, state_binary, state_boolean;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      state_binary = binary.slice(31, 35);
      switch (state_binary) {
        case "1001":
          state_boolean = false;
          break;
        case "1000":
          state_boolean = true;
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 30),
        state: state_boolean
      };
    },
    encodeMessage: function(message) {
      var id, state_binary, state_pulse;
      id = helper.map(helper.numberToBinary(message.id, 31), binaryToPulse);
      switch (message.state) {
        case false:
          state_binary = "1001";
          break;
        case true:
          state_binary = "1000";
      }
      state_pulse = helper.map(state_binary, binaryToPulse);
      return "32" + id + state_pulse + state_pulse + "1032" + id + state_pulse + state_pulse + "14";
    }
  };
};
