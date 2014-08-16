module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0110': '0',
    '0101': '1',
    '02': ''
  };
  return protocolInfo = {
    name: 'switch4',
    type: 'switch',
    values: {
      unit: {
        type: "number"
      },
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Cogex", "KlikAanKlikUit", "Intertechno", "Düwi Terminal"],
    pulseLengths: [295, 1180, 11210],
    pulseCount: 50,
    parse: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary, 0, 5),
        id: helper.binaryToNumber(binary, 6, 10),
        state: helper.binaryToBoolean(binary, 12)
      };
    }
  };
};
