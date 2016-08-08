module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '0': '0',
    '1': '1',
    '2': ''
  };
  binaryToPulse = {
    '0': '0',
    '1': '1'
  };
  return protocolInfo = {
    name: 'switch29',
    type: 'switch',
    commands: ["arm", "disarm", "home", "panic", "grp1", "grp2", "grp3"],
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      command: {
        type: "number"
      }
    },
    brands: ["Meiantech", "Atlantic", "Aidebao", "PB-403R"],
    pulseLengths: [404, 804, 4028],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, command, commandcode, id, result, unit;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      id = helper.binaryToNumber(binary, 0, 24);
      unit = helper.binaryToNumber(binary, 25, 48);
      command = helper.binaryToNumber(binary, 49, 72);
      commandcode = pulses.slice(49, 73);
      switch (commandcode) {
        case "011001010101100101101010":
          command = "arm";
          break;
        case "010101100101100101011001":
          command = "panic";
          break;
        case "100101010101100110011010":
          command = "disarm";
          break;
        case "010110010101100101010110":
          command = "home";
          break;
        case "101001010101100110101010":
          command = "grp1";
          break;
        case "100110010101100110010110":
          command = "grp2";
          break;
        case "101010010101100110100110":
          command = "grp3";
      }
      return result = {
        id: id,
        unit: unit,
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id, unit;
      id = helper.map(helper.numberToBinary(message.id, 25), binaryToPulse);
      unit = helper.map(helper.numberToBinary(message.unit, 24), binaryToPulse);
      switch (message.command) {
        case "arm":
          commandcode = "011001010101100101101010";
          break;
        case "panic":
          commandcode = "010101100101100101011001";
          break;
        case "disarm":
          commandcode = "100101010101100110011010";
          break;
        case "home":
          commandcode = "010110010101100101010110";
          break;
        case "grp1":
          commandcode = "101001010101100110101010";
          break;
        case "grp2":
          commandcode = "100110010101100110010110";
          break;
        case "grp3":
          commandcode = "101010010101100110100110";
      }
      return "" + id + unit + commandcode + "2";
    }
  };
};
