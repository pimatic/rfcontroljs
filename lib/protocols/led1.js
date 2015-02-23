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
    name: 'led1',
    type: 'command',
    values: {
      id: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["LED Stripe RF Dimmer (no name)"],
    pulseLengths: [348, 1051, 10864],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(21, 24);
      switch (commandcode) {
        case "001":
          command = "on/off";
          break;
        case "100":
          command = "up";
          break;
        case "010":
          command = "down";
          break;
        default:
          command = "unkown command " + commandcode;
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 20),
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id;
      id = helper.map(helper.numberToBinary(message.id, 21), binaryToPulse);
      switch (message.command) {
        case "on/off":
          commandcode = "001";
          break;
        case "up":
          commandcode = "100";
          break;
        case "down":
          commandcode = "010";
          break;
        default:
          return "0";
      }
      return "" + id + commandcode + "02";
    }
  };
};
