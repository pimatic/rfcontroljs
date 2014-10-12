module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0102': '1',
    '0201': '0',
    '03': ''
  };
  return protocolInfo = {
    name: 'generic',
    type: 'value',
    values: {
      id: {
        type: "number"
      },
      type: {
        type: "number"
      },
      positive: {
        type: "boolean"
      },
      value: {
        type: "number"
      }
    },
    brands: ["homemade"],
    pulseLengths: [671, 2049, 4346, 10208],
    pulseCount: 198,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 13),
        type: helper.binaryToNumber(binary, 14, 17),
        positive: helper.binaryToNumber(binary, 18, 18),
        value: helper.binaryToNumber(binary, 19, 48)
      };
    }
  };
};
