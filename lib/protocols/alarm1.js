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
	  state: {
        type: "boolean"
      }
    },
    brands: ["FA20RF"],
    pulseLengths: [750, 1423, 2760, 8040, 12000, 920],
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
      var unit, pulse, pulses, i;
	  
	  if(message.state == false)
		return "0";
	
      unit = helper.map(helper.numberToBinary(message.unit, 24), binaryToPulse);
	  
	  pulses = "";
	  pulse = "35" + unit  + "04"+"35" + unit;
	  
	  i = 0
	  while(i <= 5) {
		i++;
		pulses += pulse;
	  }
	  
      return  pulses;
	  //return "3002020101010102020201010101020101010102020202010204";
    }
  };
};
