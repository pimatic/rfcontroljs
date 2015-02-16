module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '1',
    '00': '0',
    '02': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '00'
  };
  return protocolInfo = {
    name: 'switch10',
    type: 'switch',
    values: {
      systemcode: {
        type: "number"
      },
      state: {
        type: "boolean"
      },
	  all: {
		type: "boolean"
	  },
      unit: {
        type: "number"
      }
    },
    brands: ["Home Easy Advanced"],
    pulseLengths: [ 271, 1254, 10092 ],
    pulseCount: 116,
    decodePulses: function(pulses) {
      var binary, result, groupcode, groupcode2, groupRes,id2;
      binary = helper.map(pulses, pulsesToBinaryMapping);

	  groupRes = false;
	  groupcode = helper.binaryToNumber(binary, 43, 46);
	  groupcode2 = helper.binaryToNumber(binary, 49, 50);
	  
	  if(groupcode == 11 && groupcode2 == 1) {
		groupRes = false;
	  } else if(groupcode == 3 && groupcode2 == 3) {
		groupRes = true;
	  }
	  
	  id2 = helper.binaryToNumber(binary, 11, 42)>>>0
	  
      return result = {
        systemcode: id2,
        unit: helper.binaryToNumber(binary, 51, 56),
		all: groupRes,
        state: (helper.binaryToNumber(binary, 47, 48) == 1 ? false : true)
      };
    },
    encodeMessage: function(message) {
      var systemcode, state, unit, groupcode, groupcode2;
      systemcode = helper.map(helper.numberToBinary(message.systemcode, 32), binaryToPulse);
      state = (message.state ? helper.map(helper.numberToBinary(2, 2), binaryToPulse) : helper.map(helper.numberToBinary(1, 2), binaryToPulse));
      unit = helper.map(helper.numberToBinary(message.unit, 6), binaryToPulse);
	  groupcode = (message.all ? helper.map(helper.numberToBinary(3, 4), binaryToPulse) : helper.map(helper.numberToBinary(11, 4), binaryToPulse));
	  groupcode2 = (message.all ? helper.map(helper.numberToBinary(3, 2), binaryToPulse) : helper.map(helper.numberToBinary(1, 2), binaryToPulse));
	  
      return helper.map("11000111100", binaryToPulse) + systemcode + groupcode + state + groupcode2 + unit + "0102";
    }
  };
};
