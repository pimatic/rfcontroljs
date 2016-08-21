module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '',
    '0100': '1',
    '0001': '0',
    '03': ''
  };
  binaryToPulse = {
    '1': '0100',
    '0': '0001'
  };
  return protocolInfo = {
    name: 'contact1',
    type: 'contact',
    values: {
      id: {
        type: "number"
      },
      all: {
        type: "boolean"
      },
      contact: {
        type: "boolean"
      },
      unit: {
        type: "number"
      }
    },
    brands: ["KlikAanKlikUit"],
    pulseLengths: [268, 1282, 2632, 10168],
    pulseCounts: [132, 148],
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 25),
        all: helper.binaryToBoolean(binary, 26),
        contact: !helper.binaryToBoolean(binary, 27),
        unit: helper.binaryToNumber(binary, 28, 31)
      };
    }
  };
};
