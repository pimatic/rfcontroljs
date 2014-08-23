module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather2',
    type: 'weather',
    values: {
      temperature: {
        type: "number"
      }
    },
    models: ["Auriol"],
    pulseLengths: [492, 969, 1948, 4004],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        temperature: helper.binaryToNumber(binary, 15, 23) / 10
      };
    }
  };
};
