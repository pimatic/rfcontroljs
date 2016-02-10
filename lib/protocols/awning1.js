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
    name: 'awning1',
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
    brands: ["awningCode"],
    pulseLengths: [352, 740, 1580, 4720, 7772],
    pulseCount: 164,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(31, 35);
      command = ((function() {
        switch (commandcode) {
          case '1001':
            return 'in';
          case '1000':
            return 'out';
          case '1010':
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
            return '1001';
          case 'out':
            return '1000';
          case 'stop':
            return '1010';
        }
      })());
      commandcode = helper.map(commandcode, binaryToPulse);
      return "32" + id + commandcode + commandcode + "1032" + id + commandcode + commandcode + "14";
    }
  };
};
