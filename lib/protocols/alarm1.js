module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '30': '',
    '01': '0',
    '02': '1',
    '04': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '02'
  };
  return protocolInfo = {
    name: 'alarm1',
    type: 'switch',
    values: {
      unit: {
        type: "number"
      },
      id: {
        type: "number"
      },
      presence: {
        type: "boolean"
      }
    },
    brands: ["FA20RF"],
    pulseLengths: [800, 1423, 2760, 8040, 13000],
    pulseCount: 52,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary, 0, 23),
        state: true
      };
    },
    encodeMessage: function(message) {
      var i, pulse, pulses, unit;
      if (message.state === false) {
        return "0";
      }
      unit = helper.map(helper.numberToBinary(message.unit, 24), binaryToPulse);
      pulses = "";
      pulse = "30" + unit + "0430" + unit;
      i = 0;
      while (i <= 5) {
        i++;
        pulses += "" + pulses + pulse;
      }
      return pulses;
    }
  };
};
