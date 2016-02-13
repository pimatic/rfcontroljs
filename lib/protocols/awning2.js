module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '32': '',
    '01': '0',
    '10': '1',
    '14': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'awning2',
    type: 'command',
    commands: ["in", "out", "stop"],
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["Soluna"],
    pulseLengths: [359, 718, 1532, 4740, 10048],
    pulseCount: 82,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(33, 39);
      command = ((function() {
        switch (commandcode) {
          case '001000':
            return 'in';
          case '011001':
            return 'out';
          case '101010':
            return 'stop';
        }
      })());
      return result = {
        id: helper.binaryToNumber(binary, 0, 30),
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 31), binaryToPulse);
      commandcode = ((function() {
        switch (message.command) {
          case 'in':
            return '001000';
          case 'out':
            return '011001';
          case 'stop':
            return '101010';
        }
      })());
      commandcode = helper.map(commandcode, binaryToPulse);
      return "32" + id + "1001" + commandcode + "14";
    }
  };
};
