module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'generic',
    type: 'generic',
    values: {
      id: {
        type: "number"
      },
      proto: {
        type: "number"
      },
      positive: {
        type: "boolean"
      },
      counter: {
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
        id: 1000,
        proto: 10,
        positive: true,
        counter: 6
      };
    }
  };
};
