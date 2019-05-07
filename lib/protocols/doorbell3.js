module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '10': '1',
    '2': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'doorbell3',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      }
    },
    brands: ["Smarthome WP515S"],
    pulseLengths: [300, 580, 10224],
    pulseCount: 26,
    decodePulses: function(pulses) {
      var binary, result, src;
      src = pulses.substring(1);
      binary = helper.map(src, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 3),
        unit: helper.binaryToNumber(binary, 4, 11)
      };
    },
    encodeMessage: function(message) {
      var id, unit;
      id = helper.map(helper.numberToBinary(message.id, 4), binaryToPulse);
      unit = helper.map(helper.numberToBinary(message.unit, 8), binaryToPulse);
      return "0" + id + unit + "2";
    }
  };
};
