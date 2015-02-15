module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
	'30': '',
    '01': '0',
    '02': '1',
    '204': ''
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
        unit: helper.binaryToNumber(binary, 0, 4),
		state: true
      };
    },
    encodeMessage: function(message) {
      var fixed, id, invertedState, unit;
      unit = helper.map(helper.numberToBinary(message.unit, 5), binaryToPulse);
      id = helper.map(helper.numberToBinary(message.id, 5), binaryToPulse);
      fixed = binaryToPulse['0'];
      invertedState = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + unit + id + fixed + invertedState + "02";
    }
  };
};
