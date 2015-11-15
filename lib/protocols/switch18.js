module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '02': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '10'
  };
  return protocolInfo = {
    name: 'relay',
    type: 'command',
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["Relay 4CH switch"],
    pulseLengths: [376, 1144, 11720],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(20, 24);
      command = ((function() {
        switch (commandcode) {
          case '1110':
            return 'A';
          case '1101':
            return 'B';
          case '1011':
            return 'C';
	  case '0111':
            return 'D';
        }
      })());
      return result = {
        id: helper.binaryToNumber(binary, 0, 19),
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 20), binaryToPulse);
      commandcode = ((function() {
        switch (message.command) {
          case 'A':
            return '1110';
          case 'B':
            return '1101';
          case 'C':
            return '1011';
          case 'D':
            return '0111';
        }
      })());
      commandcode = helper.map(commandcode, binaryToPulse);
      return "" + id + commandcode + "02";
    }
  };
};
