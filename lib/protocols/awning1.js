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
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["awningCode"],
    pulseLengths: [376, 732, 1560, 4736, 7768],
    pulseCounts: 168,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(31, 35);
      switch (commandcode) {
        case "1001":
          command = "in";
          break;
        case "1000":
          command = "out";
          break;
        case "1010":
          command = "stop";
          break;
        default:
          command = "code:" + commandcode;
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 30),
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 31), binaryToPulse);
      switch (message.command) {
        case "in":
          commandcode = "1001";
          break;
        case "out":
          commandcode = "1000";
          break;
        case "stop":
          commandcode = "1010";
          break;
        default:
          if (message.command.slice(0, 5) === "code:") {
            commandcode = message.command.slice(5);
          }
      }
      commandcode = helper.map(commandcode, binaryToPulse);
      return "32" + id + commandcode + commandcode + "1032" + id + commandcode + commandcode + "14";
    }
  };
};
