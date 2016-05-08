module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0110': '1',
    '0101': '0',
    '1010': '2',
    '02': ''
  };
  binaryToPulse = {
    '1': '0110',
    '0': '0101',
    '2': '1010'
  };
  return protocolInfo = {
    name: 'switch26',
    type: 'switch',
    values: {
      channel: {
        type: "string"
      },
      unit: {
        type: "string"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Chacon EMW200TC"],
    pulseLengths: [480, 1476, 15260],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, channel, channelCode, commandCode, result, state, unit, unitCode;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      channelCode = binary.slice(0, 3);
      channel = ((function() {
        switch (channelCode) {
          case '011':
            return 'A';
          case '101':
            return 'B';
          case '110':
            return 'C';
          default:
            return channelCode;
        }
      })());
      unitCode = binary.slice(3, 7);
      unit = ((function() {
        switch (unitCode) {
          case '0111':
            return '1';
          case '1011':
            return '2';
          case '1101':
            return '3';
          case '1110':
            return '4';
          default:
            return unitCode + binary.slice(7, 11);
        }
      })());
      commandCode = binary[11];
      if (commandCode === '2') {
        state = true;
      } else {
        state = false;
      }
      return result = {
        channel: channel,
        unit: unit,
        state: state
      };
    },
    encodeMessage: function(message) {
      var channelCode, commandCode, unitCodeAndConstant;
      channelCode = ((function() {
        switch (message.channel) {
          case 'A':
            return '011';
          case 'B':
            return '101';
          case 'C':
            return '110';
          default:
            return message.channel;
        }
      })());
      unitCodeAndConstant = ((function() {
        switch (message.unit) {
          case '1':
            return '01111111';
          case '2':
            return '10111111';
          case '3':
            return '11011111';
          case '4':
            return '11101111';
          default:
            return message.unit;
        }
      })());
      if (message.state) {
        commandCode = '2';
      } else {
        commandCode = '0';
      }
      channelCode = helper.map(channelCode, binaryToPulse);
      unitCodeAndConstant = helper.map(unitCodeAndConstant, binaryToPulse);
      commandCode = helper.map(commandCode, binaryToPulse);
      return "" + channelCode + unitCodeAndConstant + commandCode + "02";
    }
  };
};
