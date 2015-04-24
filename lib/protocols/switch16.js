module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0101': '0',
    '1010': '1',
    '0110': '2',
    '02': ''
  };
  binaryToPulse = {
    '2': '0110',
    '0': '0101',
    '1': '1010'
  };
  return protocolInfo = {
    name: 'switch16',
    type: 'switch',
    values: {
      systemcode: {
        type: "number"
      },
      programcode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Everflourish"],
    pulseLengths: [330, 1000, 10500],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, id, result, state, unit;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      state = helper.binaryToBoolean(binary, 11);
      id = String.fromCharCode(64 + this.binaryToNumber(binary, 0, 3));
      unit = this.binaryToNumber(binary, 4, 6);
      return result = {
        id: id,
        unit: unit,
        state: state
      };
    },
    encodeMessage: function(message) {
      var idCharNum, idParts, state, unit;
      unit = helper.map(helper.numberToBinary(message.unit, 3), {
        '1': '0101',
        '0': '0110'
      });
      idCharNum = message.id.charCodeAt(0) - 65;
      if (idCharNum > 3) {
        idCharNum = 3;
      }
      idParts = ['0110', '0110', '0110', '0110'];
      idParts[idCharNum] = '0101';
      state = (message.state ? binaryToPulse['1'] : binaryToPulse['0']);
      return "" + idParts[0] + idParts[1] + idParts[2] + idParts[3] + unit + "0110011001100110" + state + "02";
    },
    binaryToNumber: function(data, b, e) {
      var c, i;
      c = 1;
      i = b;
      while (i < e) {
        if (data[i] === '0') {
          break;
        }
        i++;
        c++;
      }
      return c;
    }
  };
};
