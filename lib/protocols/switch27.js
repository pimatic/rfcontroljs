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
    name: 'switch27',
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
    brands: ["Chacon Zen (EMW200TB)"],
    pulseLengths: [325, 972, 10130],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, channel, channelCode, result, state, unit, unitCode;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      channelCode = binary.slice(0, 4);
      channel = ((function() {
        switch (channelCode) {
          case '1111':
            return 'A';
          case '1011':
            return 'B';
          case '1101':
            return 'C';
          case '1110':
            return 'D';
          default:
            return channelCode;
        }
      })());
      unitCode = binary.slice(4, 9);
      unit = ((function() {
        switch (unitCode) {
          case '01111':
            return '1';
          case '10111':
            return '2';
          case '11011':
            return '3';
          default:
            return unitCode + binary.slice(9, 11);
        }
      })());
      state = binary[11] === '2';
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
            return '1111';
          case 'B':
            return '1011';
          case 'C':
            return '1101';
          case 'D':
            return '1110';
          default:
            return message.channel;
        }
      })());
      unitCodeAndConstant = ((function() {
        switch (message.unit) {
          case '1':
            return '0111111';
          case '2':
            return '1011111';
          case '3':
            return '1101111';
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
