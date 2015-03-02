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
    pulseLengths: [439, 1240, 12944],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      commandcode = binary.slice(16, 24);
      switch (commandcode) {
        case "00100001":
          command = "on/off";
          break;
        case "00100100":
          command = "up";
          break;
        case "00100010":
          command = "down";
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
          commandcode = "00100001";
          break;
        case "up":
          commandcode = "00100100";
          break;
        case "down":
          commandcode = "00100010";
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
