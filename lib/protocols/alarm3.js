module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '10',
    '01': '01',
    '02': '',
    '12': '',
    '00': '',
    '11': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '02'
  };
  return protocolInfo = {
    name: 'alarm3',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Smartwares RM174RF (provisional)"],
    pulseLengths: [472, 1236, 11688],
    pulseCount: 54,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 23),
        state: true
      };
    },
    encodeMessage: function(message) {
      var unit;
      if (message.state === false) {
        return "0";
      }
      unit = helper.map(helper.numberToBinary(message.id, 24), binaryToPulse);
      return "{unit}000102";
    }
  };
};
