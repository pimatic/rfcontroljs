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
    name: 'shutter1',
    type: 'command',
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["Nobily"],
    pulseLengths: [280, 736, 1532, 4752, 7796],
    pulseCount: 164,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(31, 35);
      command = ((function() {
        switch (commandcode) {
          case '1000':
            return 'up';
          case '1001':
            return 'down';
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
          case 'up':
            return '1000';
          case 'down':
            return '1001';
          case 'stop':
            return '1010';
        }
      })());
      commandcode = helper.map(commandcode, binaryToPulse);
      return "32" + id + commandcode + commandcode + "1032" + id + commandcode + commandcode + "14";
    }
  };
};
