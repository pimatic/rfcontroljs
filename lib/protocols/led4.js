module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '11': '1',
    '02': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'led4',
    type: 'command',
    commands: ["on/off", "bright+", "bright-", "color-", "color+"],
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["LED Controller"],
    pulseLengths: [345, 967, 9484],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(16, 24);
      switch (commandcode) {
        case "10000101":
          command = "on/off";
          break;
        case "10000011":
          command = "bright+";
          break;
        case "10000010":
          command = "bright-";
          break;
        case "10000111":
          command = "color-";
          break;
        case "10000110":
          command = "color+";
          break;
        default:
          command = "code:" + commandcode;
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 15),
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse);
      switch (message.command) {
        case "on/off":
          commandcode = "10000101";
          break;
        case "bright+":
          commandcode = "10000011";
          break;
        case "bright-":
          commandcode = "10000010";
          break;
        case "color-":
          commandcode = "10000111";
          break;
        case "color+":
          commandcode = "10000110";
          break;
        default:
          if (message.command.slice(0, 5) === "code:") {
            commandcode = message.command.slice(5);
          }
      }
      commandcode = helper.map(commandcode, binaryToPulse);
      return "" + id + commandcode + "02";
    }
  };
};
