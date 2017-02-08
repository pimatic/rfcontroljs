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
    name: 'pir6',
    type: 'pir',
    values: {
      id: {
        type: "number"
      },
      presence: {
        type: "boolean"
      }
    },
    brands: ["Zanbo (ZABC86-1)", "Unknown (OSW-1-3 and OTW-1-3)"],
    pulseLengths: [288, 864, 8964],
    pulseCounts: [50],
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 2, 24),
        presence: true
      };
    }
  };
};
