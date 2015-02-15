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
        type: "string"
      },
	  state: {
        type: "boolean"
      }
    },
    brands: ["FA20RF"],
    pulseLengths: [745, 1460, 2800, 8080, 17300],
    pulseCount: 52,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unit: helper.binaryToNumber(binary,0,23),
		state: true
      };
    },
    encodeMessage: function(message) {
      var unit;
      unit = helper.map(helper.numberToBinary(message.unit, 24), binaryToPulse);
      return "30" + unit  + "04";
    }
  };
};
