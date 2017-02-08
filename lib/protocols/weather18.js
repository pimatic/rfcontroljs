module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '0003': ''
  };
  return protocolInfo = {
    name: 'weather18',
    type: 'weather',
    values: {
      temperature: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      id: {
        type: "number"
      }
    },
    brands: ["Mebus/Renkforce E0190T"],
    pulseLengths: [496, 960, 1940, 3904],
    pulseCount: 76,
    decodePulses: function(pulses) {
      var binary, lowBattery, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      lowBattery = !helper.binaryToBoolean(binary, 8);
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 10, 11) + 1,
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10
      };
    }
  };
};
