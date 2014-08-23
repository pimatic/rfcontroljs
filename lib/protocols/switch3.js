module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0110': '0',
    '0101': '1',
    '02': ''
  };
  return protocolInfo = {
    name: 'switch3',
    type: 'switch',
    values: {
      houseCode: {
        type: "number"
      },
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Brennenstuhl Comfort", "Elro Home Control"],
    pulseLengths: [306, 957, 9808],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        houseCode: helper.binaryToNumber(binary, 0, 5),
        unitCode: helper.binaryToNumber(binary, 6, 10),
        state: helper.binaryToBoolean(binary, 12)
      };
    }
  };
};
