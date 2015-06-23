module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '02': '0',
    '21': '1',
    '03': ''
  };
  binaryToPulse = {
    '0': '02',
    '1': '21'
  };
  return protocolInfo = {
    name: 'shutter5',
    type: 'command',
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      }
    },
    brands: ["eSmart"],
    pulseLengths: [160, 270, 665, 6856],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(20, 23);
      command = ((function() {
        switch (commandcode) {
          case '001':
            return 'up';
          case '010':
            return 'down';
          case '100':
            return 'stop';
        }
      })());
      return result = {
        id: helper.binaryToNumber(binary, 0, 19),
        command: command
      };
    },
    encodeMessage: function(message) {
      var command, commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 20), binaryToPulse);
      commandcode = ((function() {
        switch (message.command) {
          case 'up':
            return '001';
          case 'down':
            return '010';
          case 'stop':
            return '100';
        }
      })());
      command = helper.map(commandcode, binaryToPulse);
      return "" + id + command + "0203";
    }
  };
};
