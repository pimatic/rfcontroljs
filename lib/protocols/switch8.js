module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0101': '1',
    '1010': '2',
    '0110': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '0110',
    '1': '0101',
    '2': '1010'
  };
  return protocolInfo = {
    name: 'switch8',
    type: 'switch',
    values: {
      systemcode: {
        type: "number"
      },
      programcode: {
        type: "string"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Rev"],
    pulseLengths: [189, 547, 5720],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result, state, unit;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      unit = this.binaryToChar(binary, 5, 9);
      if (binary[11] === '2') {
        state = true;
      } else {
        state = false;
      }
      binary = helper.map(binary, {
        '2': '0',
        '1': '1',
        '0': '0'
      });
      unit = '' + unit + helper.binaryToNumberMSBLSB(binary, 5, 9);
      return result = {
        systemcode: helper.binaryToNumberMSBLSB(binary, 0, 4),
        programcode: unit,
        state: state
      };
    },
    encodeMessage: function(message) {
      var inverseState, programcode1, programcode2, programcode3, state, systemcode, unit, unit2, unitChar;
      systemcode = helper.map(helper.numberToBinaryMSBLSB(message.systemcode, 5), binaryToPulse);
      unitChar = message.programcode.charCodeAt(0) - 65;
      unit2 = message.programcode.slice(1, message.programcode.length);
      unit = parseInt(unit2, 10);
      programcode1 = helper.numberToBinaryMSBLSB(unit, 5);
      programcode2 = programcode1.substr(0, 4 - unitChar) + '2' + programcode1.substr(5 - unitChar);
      programcode3 = helper.map(programcode2, binaryToPulse);
      inverseState = (message.state ? binaryToPulse['1'] : binaryToPulse['2']);
      state = (message.state ? binaryToPulse['2'] : binaryToPulse['1']);
      return "" + systemcode + programcode3 + inverseState + state + "02";
    },
    binaryToChar: function(data, b, e) {
      var c, i;
      c = 0;
      i = e;
      while (i >= b) {
        if (data[i] === '2') {
          break;
        }
        i--;
        c++;
      }
      return String.fromCharCode(65 + c);
    }
  };
};
