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
    | 0    | 1                                                                                                                            26   | 27    | 28             31   |
    | 0200 | 0200 0200 0002 0002 0002 0200 0200 0200 0200 0200 0002 0200 0002 0200 0200 0200 0200 0200 0200 0200 0200 0002 0002 0200 0002 0002 | 0200  | 0200 0200 0002 0200 | On
    | 0200 | 0200 0200 0002 0002 0002 0200 0200 0200 0200 0200 0002 0200 0002 0200 0200 0200 0200 0200 0200 0200 0200 0002 0002 0200 0002 0002 | 0002  | 0200 0200 0002 0200 | Off
    |      | id                                                                                                                                | state | unit                |
    |      | 52387812                                                                                                                          | 27    | 13                  |
    |      | It's not yet sure where the id starts until more than 1 set can be used for finding the changes in the pattern.                   |       |                     |
    |      | I decided to take bit 1 to 26, in the manual is written 67 million codes (2^26). So this is still beta.                           |       |                     |
	*/
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumber(binary, 1, 26),
        unit: helper.binaryToNumber(binary, 28, 31),
        state: helper.binaryToBoolean(binary, 27)
      };
    },
    encodeMessage: function(message) {
      var id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 26), binaryToPulse);
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      unit = helper.map(helper.numberToBinary(message.unit, 4), binaryToPulse);
      return "010200" + id + state + unit + "03";
    }
  };
};

