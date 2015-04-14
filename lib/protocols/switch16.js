module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0200': '1',
    '0002': '0',
    '01': '',
    '03': ''
  };
  binaryToPulse = {
    '1': '0200',
    '0': '0002'
  };
  return protocolInfo = {
    name: 'switch16',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
	  all: {
	    type: "boolean"
	  },
      state: {
        type: "boolean"
      },
      unit: {
        type: "number"
      }
    },
    brands: ["Intertek 22541673 (z.B. Bauhaus)"],
    pulseLengths: [260, 2680, 1275, 10550],
    pulseCount: 132,
    decodePulses: function(pulses) {
    /*
    | 0                                                                                                                            25   | 26   | 27    | 28             31   |
    | 0200 0200 0200 0002 0002 0002 0200 0200 0200 0200 0200 0002 0200 0002 0200 0200 0200 0200 0200 0200 0200 0200 0002 0002 0200 0002 | 0002 | 0200  | 0200 0200 0002 0200 | On
    | 0200 0200 0200 0002 0002 0002 0200 0200 0200 0200 0200 0002 0200 0002 0200 0200 0200 0200 0200 0200 0200 0200 0002 0002 0200 0002 | 0002 | 0002  | 0200 0200 0002 0200 | Off
    | id                                                                                                                                | all  | state | unit                |
    | 52387812                                                                                                                          |      |       | 13                  |
    */
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 0, 25),
        all: helper.binaryToBoolean(binary, 26),
        state: helper.binaryToBoolean(binary, 27),
        unit: helper.binaryToNumber(binary, 28, 31)
      };
    },
    encodeMessage: function(message) {
      var id, all, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse);
      all = (message.all ? binaryToPulse['1'] : binaryToPulse['0']);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse);
      return "01" + id + all + state + unit + "03";
    }
  };
};

