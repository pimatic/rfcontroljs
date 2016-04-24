module.exports = function(helper) {
  var protocolInfo;
  return protocolInfo = {
    name: 'switch28',
    type: 'command',
    commands: ["on", "off", "both"],
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      command: {
        type: "string"
      }
    },
    brands: ["oh!haus & Co."],
    pulseLengths: [417, 1287, 13042],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var command, commandcode, result;
      commandcode = pulses.slice(40, 48);
      switch (commandcode) {
        case "01011010":
          command = "on";
          break;
        case "10100101":
          command = "off";
          break;
        case "01010101":
          command = "both";
      }
      return result = {
        id: helper.binaryToNumber(pulses, 0, 24),
        unit: helper.binaryToNumber(pulses, 25, 39),
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id, unit;
      id = helper.numberToBinary(message.id, 25);
      unit = helper.numberToBinary(message.unit, 15);
      switch (message.command) {
        case "on":
          commandcode = "01011010";
          break;
        case "off":
          commandcode = "10100101";
          break;
        case "both":
          commandcode = "01010101";
      }
      return "" + id + unit + commandcode + "02";
    }
  };
};
