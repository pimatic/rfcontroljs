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
    name: 'led2',
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
    pulseLengths: [441, 1218, 13012],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(16, 24);
      switch (commandcode) {
        case "00000001":
          command = "on/off";
          break;
        case "00000100":
          command = "light";
          break;
        case "00000101":
          command = "bright+";
          break;
        case "00000110":
          command = "bright-";
          break;
        case "00000111":
          command = "100%";
          break;
        case "00001000":
          command = "50%";
          break;
        case "00001001":
          command = "25%";
          break;
        case "00001011":
          command = "mode+";
          break;
        case "00010001":
          command = "mode-";
          break;
        case "00001111":
          command = "speed+";
          break;
        case "00001101":
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
        case "light":
          commandcode = "00000100";
          break;
        case "bright+":
          commandcode = "00000101";
          break;
        case "bright-":
          commandcode = "00000110";
          break;
        case "100%":
          commandcode = "00000111";
          break;
        case "50%":
          commandcode = "00001000";
          break;
        case "25%":
          commandcode = "00001001";
          break;
        case "mode+":
          commandcode = "00001011";
          break;
        case "mode-":
          commandcode = "00010001";
          break;
        case "speed+":
          commandcode = "00001111";
          break;
        case "speed-":
          commandcode = "00001101";
          break;
        default:
          if (message.command.slice(0, 5) === "code:") {
            return "" + id + message.command.slice(5) + "02";
          } else {
            return "0";
          }
      }
      return "" + id + commandcode + "02";
    }
  };
};
