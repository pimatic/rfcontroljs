module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '32': '',
    '01': '0',
    '10': '1',
    '04': '',
    '14': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'shutter3',
    type: 'command',
    commands: ["up", "down", "stop", "program"],
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["Romotec"],
    pulseLengths: [366, 736, 1600, 5204, 10896],
    pulseCount: 82,
    decodePulses: function(pulses) {
      var binary, command, commandCode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandCode = binary.slice(33, 36);
      command = ((function() {
        switch (commandCode) {
          case '001':
            return 'up';
          case '011':
            return 'down';
          case '101':
            return 'stop';
          case '100':
            return 'program';
        }
      })());
      return result = {
        id: helper.binaryToNumber(binary, 0, 27),
        channel: helper.binaryToNumber(binary, 28, 31),
        command: command
      };
    },
    encodeMessage: function(message) {
      var channel, command, commandCode, id;
      id = helper.map(helper.numberToBinary(message.id, 28), binaryToPulse);
      channel = helper.map(helper.numberToBinary(message.channel, 4), binaryToPulse);
      commandCode = ((function() {
        switch (message.command) {
          case 'up':
            return '001000';
          case 'down':
            return '011001';
          case 'stop':
            return '101010';
          case 'program':
            return '100110';
        }
      })());
      command = helper.map(commandCode, binaryToPulse);
      if (message.command !== 'program') {
        return "32" + id + channel + "01" + command + "14";
      } else {
        return "32" + id + channel + "10" + command + "04";
      }
    }
  };
};
