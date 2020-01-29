module.exports = function(helper) {
  var crcTable, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = [
    {
      '12222222': ''
    }, {
      '02': '0'
    }, {
      '12': '0'
    }, {
      '22': '1'
    }, {
      '20': '1'
    }, {
      '21': '1'
    }, {
      '03': ''
    }, {
      '13': ''
    }, {
      '23': ''
    }
  ];
  crcTable = helper.generateCrc8Table(0x31);
  return protocolInfo = {
    name: 'weather21',
    type: 'weather',
    values: {
      temperature: {
        type: "number"
      },
      humidity: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      id: {
        type: "number"
      },
      lowBattery: {
        type: "boolean"
      }
    },
    brands: ["Auriol HG02832, Auriol HG05124A-DCF, Auriol IAN 321304_1901, Rubicson 48957"],
    pulseLengths: [196, 288, 628, 61284],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, crcValue, digest, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      digest = [
        helper.binaryToOctets(binary, 32).reduce(function(a, b) {
          return (a ^ b) % 256;
        })
      ];
      crcValue = helper.binaryToNumber(binary, 32, 39);
      return result = {
        crcOk: crcValue === helper.crc8(crcTable, digest, 0x53),
        id: helper.binaryToNumber(binary, 0, 7),
        humidity: helper.binaryToNumber(binary, 8, 15),
        lowBattery: helper.binaryToBoolean(binary, 16),
        channel: helper.binaryToNumber(binary, 18, 19) + 1,
        temperature: helper.binaryToSignedNumber(binary, 20, 31) / 10
      };
    }
  };
};
