module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather19',
    type: 'weather',
    values: {
      temperature: {
        type: "number"
      },
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      }
    },
    brands: ["Landmann BBQ Thermometer"],
    pulseLengths: [548, 1008, 1996, 3936],
    pulseCount: 66,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 5),
        channel: helper.binaryToNumber(binary, 6, 7) + 1,
        temperature: helper.binaryToSignedNumber(binary, 8, 23) / 10
      };
    }
  };
};
