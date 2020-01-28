module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '2': ''
  };
  binaryToPulse = {
    '1': '10',
    '0': '01'
  };
  return protocolInfo = {
    name: 'switch33',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      state: {
        type: "boolean"
      },
      all: {
        type: "boolean"
      },
      dimm: {
        type: "boolean"
      }
    },
    brands: ["Lidl Powerfix RCB-I 3600R"],
    pulseLengths: [700, 1340, 15000],
    pulseCount: 42,
    decodePulses: function(pulses) {
      var binary, paritybit, paritybitRef, result;
      binary = helper.map(pulses.slice(1), pulsesToBinaryMapping);
      paritybit = helper.binaryToBoolean(binary, 19);
      paritybitRef = helper.createParityBit(binary.slice(12, 19));
      if (paritybit !== paritybitRef) {
        return result = {
          paritybit: paritybit,
          paritybitRef: paritybitRef,
          parity: parity,
          binary: binary
        };
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 11),
        unit: helper.binaryToNumber(binary, 12, 13),
        all: helper.binaryToBoolean(binary, 14),
        state: helper.binaryToBoolean(binary, 15),
        dimm: helper.binaryToBoolean(binary, 16)
      };
    },
    encodeMessage: function(message) {
      var all, bit18, dimm, id, parity, paritybit, rfstring, state, unit;
      id = helper.numberToBinary(message.id, 12);
      state = (message.state ? '1' : '0');
      all = '0';
      if (message.all != null) {
        if (message.all === true) {
          all = '1';
        }
      }
      dimm = '0';
      if (message.dimm != null) {
        if (message.dimm === true) {
          dimm = '1';
        }
      }
      unit = helper.numberToBinary(message.unit, 2);
      bit18 = unit[0];
      rfstring = "" + id + unit + all + state + dimm + "0" + bit18;
      parity = helper.createParityBit(rfstring.slice(12));
      paritybit = (parity ? binaryToPulse['1'] : binaryToPulse['0']);
      rfstring = helper.map(rfstring, binaryToPulse);
      return "0" + rfstring + paritybit + "2";
    }
  };
};
