module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '32': '',
    '01': '0',
    '10': '1',
    '03': '',
    '13': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'shutter4',
    type: 'command',
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      all: {
        type: "boolean"
      },
      command: {
        type: "string"
      }
    },
    brands: ["ROHRMOTOR24"],
    pulseLengths: [352, 712, 1476, 5690],
    pulseCount: 82,
    decodePulses: function(pulses) {
      var all, binary, channel, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      channel = helper.binaryToNumber(binary, 29, 31);
      all = ((channel = '0') ? true : false);
      commandcode = binary.slice(33, 36);
      command = ((function() {
        switch (commandcode) {
          case '001':
            return 'up';
          case '011':
            return 'down';
          case '101':
            return 'stop';
        }
      })());
      return result = {
        id: helper.binaryToNumber(binary, 0, 28),
        channel: channel,
        all: all,
        command: command
      };
    },
    encodeMessage: function(message) {
      var channel, channelcode, command, commandcode, footer, id;
      id = helper.map(helper.numberToBinary(message.id, 29), binaryToPulse);
      if (message.all) {
        channelcode = 0;
        commandcode = ((function() {
          switch (message.command) {
            case 'up':
              return '001000';
            case 'down':
              return '011001';
            case 'stop':
              return '101010';
          }
        })());
        footer = '13';
      } else {
        channelcode = message.channel;
        switch (message.command) {
          case 'up':
            commandcode = '001111';
            footer = '03';
            break;
          case 'down':
            commandcode = '011110';
            footer = '03';
            break;
          case 'stop':
            commandcode = '101010';
            footer = '13';
        }
      }
      channel = helper.map(helper.numberToBinary(channelcode, 3), binaryToPulse);
      command = helper.map(commandcode, binaryToPulse);
      return "32" + id + channel + "01" + command + footer;
    }
  };
};
