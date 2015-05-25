module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '10': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'switch19',
    type: 'switch',
    values: {
      id: {
        type: "string"
      },
      unit: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["REV Switch 008342 and Dimmer 008343"],
    pulseLengths: [472, 1436, 14776],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, id, idcode, result, state, statecode, unit, unitcode;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      idcode = binary.slice(0, 5);
      id = ((function() {
        switch (idcode) {
          case '11010':
            return 'A';
          case '01110':
            return 'B';
          case '01011':
            return 'C';
          case '01010':
            return 'D';
        }
      })());
      unitcode = binary.slice(8, 16);
      unit = ((function() {
        switch (unitcode) {
          case '11010100':
            return 1;
          case '01110100':
            return 2;
          case '01010111':
            return 3;
        }
      })());
      statecode = binary.slice(20, 24);
      state = ((function() {
        switch (statecode) {
          case '0011':
            return false;
          case '1100':
            return true;
        }
      })());
      return result = {
        id: id,
        unit: unit,
        state: state
      };
    },
    encodeMessage: function(message) {
      var id, idbin, state, statebin, unit, unitbin;
      idbin = ((function() {
        switch (message.id) {
          case 'A':
            return '11010';
          case 'B':
            return '01110';
          case 'C':
            return '01011';
          case 'D':
            return '01010';
        }
      })());
      id = helper.map(idbin, binaryToPulse);
      unitbin = ((function() {
        switch (message.unit) {
          case 1:
            return '11010100';
          case 2:
            return '01110100';
          case 3:
            return '01010111';
        }
      })());
      unit = helper.map(unitbin, binaryToPulse);
      statebin = ((function() {
        switch (message.state) {
          case false:
            return '0011';
          case true:
            return '1100';
        }
      })());
      state = helper.map(statebin, binaryToPulse);
      return "" + id + "100110" + unit + "01010101" + state + "02";
    }
  };
};
