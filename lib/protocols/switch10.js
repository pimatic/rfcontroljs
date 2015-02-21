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
      id: {
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
    brands: ["Easy Home Advanced"],
    pulseLengths: [271, 1254, 10092],
    pulseCount: 116,
    decodePulses: function(pulses) {
      var binary, groupRes, groupcode, groupcode2, id, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      groupRes = true;
      groupcode = helper.binaryToNumber(binary, 43, 46);
      groupcode2 = helper.binaryToNumber(binary, 49, 50);
      if (groupcode === 11 && groupcode2 === 1) {
        groupRes = false;
      } else if (groupcode === 12 && groupcode2 === 3) {
        groupRes = true;
      }
      id = helper.binaryToNumber(binary, 11, 42) >>> 0;
      return result = {
        id: id,
        unit: helper.binaryToNumber(binary, 51, 56),
        all: groupRes,
        state: helper.binaryToBoolean(binary, 47)
      };
    },
    encodeMessage: function(message) {
      var groupcode, groupcode2, header, id, state, unit;
      id = helper.map(helper.numberToBinary(message.id, 32), binaryToPulse);
      if (message.state === true) {
        state = helper.map(helper.numberToBinary(2, 2), binaryToPulse);
      } else {
        state = helper.map(helper.numberToBinary(1, 2), binaryToPulse);
      }
      unit = helper.map(helper.numberToBinary(message.unit, 6), binaryToPulse);
      if (message.all != null) {
        if (message.all === true) {
          groupcode = helper.map(helper.numberToBinary(11, 4), binaryToPulse);
          groupcode2 = helper.map(helper.numberToBinary(1, 2), binaryToPulse);
        }
      } else {
        groupcode = helper.map(helper.numberToBinary(12, 4), binaryToPulse);
        groupcode2 = helper.map(helper.numberToBinary(3, 2), binaryToPulse);
      }
      header = "0101000000010101010000";
      return "" + header + id + groupcode + state + groupcode2 + unit + "02";
    }
  };
};
