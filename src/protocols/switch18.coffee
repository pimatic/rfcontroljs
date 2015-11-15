module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '0', #binary 0
    '01': '1', #binary 1
    '02': '' #footer
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
      # pulses is something like: '01100110101010101001100101010101101010010110010102'
      # we first map the sequences to binary
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      # binary is now something like: '101000000101111100011011'
      # now we extract the temperature and humidity from that string
      # | 10100000010111110001 | 1011    |
      # | ID                   | command |
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
