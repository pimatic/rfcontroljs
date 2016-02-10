module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '0',
    '01': '1',
    '2': ''
  };
  binaryToPulse = {
    '1': '01',
    '0': '10'
  };
  return protocolInfo = {
    name: 'switch23',
    type: 'command',
    commands: ["A", "B", "C", "D"],
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["Atag Cocking hood", "TXS4 Transmitter"],
    pulseLengths: [350, 720, 16000],
    pulseCount: 38,
    decodePulses: function(pulses) {
      var binary, command, commandcode, id, result;
      binary = helper.map(pulses.slice(1, 38), pulsesToBinaryMapping);
      id = helper.binaryToNumber(binary, 0, 13);
      commandcode = binary.slice(14, 18);
      command = ((function() {
        switch (commandcode) {
          case '1110':
            return 'A';
          case '1100':
            return 'B';
          case '1011':
            return 'C';
          case '1001':
            return 'D';
        }
      })());
      return result = {
        id: id,
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 14), binaryToPulse);
      commandcode = ((function() {
        switch (message.command) {
          case 'A':
            return '1110';
          case 'B':
            return '1100';
          case 'C':
            return '1011';
          case 'D':
            return '1001';
          default:
            return '1110';
        }
      })());
      commandcode = helper.map(commandcode, binaryToPulse);
      return "0" + id + commandcode + "2";
    }
  };
};
