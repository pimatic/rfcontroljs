module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather10',
    type: 'weather',
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      temperature: {
        type: "number"
      }
    },
    brands: ["Velleman WS8426S"],
    pulseLengths: [492, 969, 1948, 4004],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, channel, id, result, temperature;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      id = helper.binaryToNumber(binary, 0, 9);
      channel = helper.binaryToNumber(binary, 10, 11) + 1;
      temperature = helper.binaryToSignedNumber(binary, 12, 23) / 10;
      return result = {
        id: id,
        channel: channel,
        temperature: temperature
      };
    }
  };
};
