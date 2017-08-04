module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '10': '1',
    '23': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'rolling1',
    type: 'switch',
    values: {
      codeOn: {
        type: "string"
      },
      codeOff: {
        type: "string"
      }
    },
    brands: ["rollingCode"],
    pulseLengths: [500, 1000, 3000, 7250],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        code: binary
      };
    },
    encodeMessage: function(message) {
      var code;
      if (message.state === true) {
        code = helper.map(message.codeOn[0], binaryToPulse);
      } else {
        code = helper.map(message.codeOff[0], binaryToPulse);
      }
      return code + "23";
    }
  };
};
