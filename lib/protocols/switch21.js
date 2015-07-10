var nibbleToNumber, numberToNibble;

module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '1',
    '02': '0',
    '03': ''
  };
  binaryToPulse = {
    '0': '02',
    '1': '01'
  };
  return protocolInfo = {
    name: 'switch21',
    type: 'switch',
    values: {
      remoteCode: {
        type: "number"
      },
      unitCode: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["LightwaveRF"],
    pulseLengths: [204, 328, 1348, 10320],
    pulseCount: 144,
    decodePulses: function(pulses) {
      var binary, nstate, remoteCode, result, state, unitCode;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      unitCode = nibbleToNumber(helper.binaryToNumber(binary, 15, 21));
      nstate = nibbleToNumber(helper.binaryToNumber(binary, 22, 28));
      if (nstate) {
        state = true;
      } else {
        state = false;
      }
      remoteCode = nibbleToNumber(helper.binaryToNumber(binary, 29, 35)) * 1048576;
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 36, 42)) * 65536;
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 43, 49)) * 4096;
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 50, 56)) * 256;
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 57, 63)) * 16;
      remoteCode += nibbleToNumber(helper.binaryToNumber(binary, 64, 70));
      return result = {
        remoteCode: remoteCode,
        unitCode: unitCode,
        state: state
      };
    },
    encodeMessage: function(message) {
      var id1, id2, id3, id4, id5, id6, level, state, unitCode;
      level = helper.map(helper.numberToBinary(0x7A, 7), binaryToPulse);
      unitCode = helper.map(helper.numberToBinary(numberToNibble(message.unitCode), 7), binaryToPulse);
      if (message.state) {
        state = helper.map(helper.numberToBinary(0x76, 7), binaryToPulse);
      } else {
        state = helper.map(helper.numberToBinary(0x7A, 7), binaryToPulse);
      }
      id1 = helper.map(helper.numberToBinary(numberToNibble((Math.floor(message.remoteCode / 1048576)) & 0x0F), 7), binaryToPulse);
      id2 = helper.map(helper.numberToBinary(numberToNibble((Math.floor(message.remoteCode / 65536)) & 0x0F), 7), binaryToPulse);
      id3 = helper.map(helper.numberToBinary(numberToNibble((Math.floor(message.remoteCode / 4096)) & 0x0F), 7), binaryToPulse);
      id4 = helper.map(helper.numberToBinary(numberToNibble((Math.floor(message.remoteCode / 256)) & 0x0F), 7), binaryToPulse);
      id5 = helper.map(helper.numberToBinary(numberToNibble((Math.floor(message.remoteCode / 16)) & 0x0F), 7), binaryToPulse);
      id6 = helper.map(helper.numberToBinary(numberToNibble(message.remoteCode & 0x0F), 7), binaryToPulse);
      return "01" + level + level + unitCode + state + id1 + id2 + id3 + id4 + id5 + id6 + "03";
    }
  };
};

nibbleToNumber = function(nibble) {
  var number;
  return number = ((function() {
    switch (nibble) {
      case 0x7A:
        return 0x00;
      case 0x76:
        return 0x01;
      case 0x75:
        return 0x02;
      case 0x73:
        return 0x03;
      case 0x6E:
        return 0x04;
      case 0x6D:
        return 0x05;
      case 0x6B:
        return 0x06;
      case 0x5E:
        return 0x07;
      case 0x5D:
        return 0x08;
      case 0x5B:
        return 0x09;
      case 0x57:
        return 0x0A;
      case 0x3E:
        return 0x0B;
      case 0x3D:
        return 0x0C;
      case 0x3B:
        return 0x0D;
      case 0x37:
        return 0x0E;
      case 0x2F:
        return 0x0F;
    }
  })());
};

numberToNibble = function(number) {
  var nibble;
  return nibble = ((function() {
    switch (number) {
      case 0x00:
        return 0x7A;
      case 0x01:
        return 0x76;
      case 0x02:
        return 0x75;
      case 0x03:
        return 0x73;
      case 0x04:
        return 0x6E;
      case 0x05:
        return 0x6D;
      case 0x06:
        return 0x6B;
      case 0x07:
        return 0x5E;
      case 0x08:
        return 0x5D;
      case 0x09:
        return 0x5B;
      case 0x0A:
        return 0x57;
      case 0x0B:
        return 0x3E;
      case 0x0C:
        return 0x3D;
      case 0x0D:
        return 0x3B;
      case 0x0E:
        return 0x37;
      case 0x0F:
        return 0x2F;
    }
  })());
};
