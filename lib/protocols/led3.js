module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'led3',
    type: 'command',
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["LED Controller"],
    pulseLengths: [439, 1240, 12944],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(16, 24);
      switch (commandcode) {
        case "00000001":
          command = "on/off";
          break;
        case "00001110":
          command = "white";
          break;
        case "00010000":
          command = "red";
          break;
        case "00010001":
          command = "green";
          break;
        case "00010010":
          command = "blue";
          break;
        case "00010011":
          command = "yellow";
          break;
        case "00010100":
          command = "cyan";
          break;
        case "00010101":
          command = "magenta";
          break;
        case "00001000":
          command = "demo";
          break;
        case "00001100":
          command = "bright+";
          break;
        case "00001111":
          command = "bright-";
          break;
        case "00001101":
          command = "color-";
          break;
        case "00001010":
          command = "color+";
          break;
        case "00000101":
          command = "mode+";
          break;
        case "00001011":
          command = "mode-";
          break;
        case "00001001":
          command = "speed+";
          break;
        case "00000111":
          command = "speed-";
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
          commandcode = "00000001";
          break;
        case "white":
          commandcode = "00001110";
          break;
        case "red":
          commandcode = "00010000";
          break;
        case "green":
          commandcode = "00010001";
          break;
        case "blue":
          commandcode = "00010010";
          break;
        case "yellow":
          commandcode = "00010011";
          break;
        case "cyan":
          commandcode = "00010100";
          break;
        case "magenta":
          commandcode = "00010101";
          break;
        case "demo":
          commandcode = "00001000";
          break;
        case "bright+":
          commandcode = "00001100";
          break;
        case "bright-":
          commandcode = "00001111";
          break;
        case "color-":
          commandcode = "00001101";
          break;
        case "color+":
          commandcode = "00001010";
          break;
        case "mode+":
          commandcode = "00000101";
          break;
        case "mode-":
          commandcode = "00001011";
          break;
        case "speed+":
          commandcode = "00001001";
          break;
        case "speed-":
          commandcode = "00000111";
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
