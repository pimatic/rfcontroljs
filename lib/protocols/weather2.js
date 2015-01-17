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
    brands: ["Auriol", "Pollin (EWS-151)"],
    pulseLengths: [492, 969, 1948, 4004],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10
      };
    }
  };
};
