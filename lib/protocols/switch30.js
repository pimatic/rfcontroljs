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
    name: 'switch30',
    type: 'switch',
    commands: ["arm", "dis", "byp", "sos"],
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
    brands: ["JP-05"],
    pulseLengths: [520, 1468, 13312],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, command, commandcode, id, result, unit;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      id = helper.binaryToNumber(binary, 0, 15);
      unit = helper.binaryToNumber(binary, 16, 31);
      commandcode = pulses.slice(32, 48);
      switch (commandcode) {
        case "1010010101010101":
          command = "arm";
          break;
        case "0101010110100101":
          command = "dis";
          break;
        case "0101010101011010":
          command = "byp";
          break;
        case "0101101001010101":
          command = "sos";
      }
      return result = {
        id: id,
        unit: unit,
        command: command
      };
    },
    encodeMessage: function(message) {
      var commandcode, id, unit;
      id = helper.map(helper.numberToBinary(message.id, 16), binaryToPulse);
      unit = helper.map(helper.numberToBinary(message.unit, 16), binaryToPulse);
      switch (message.command) {
        case "arm":
          commandcode = "1010010101010101";
          break;
        case "dis":
          commandcode = "0101010110100101";
          break;
        case "byp":
          commandcode = "0101010101011010";
          break;
        case "sos":
          commandcode = "0101101001010101";
      }
      return "" + id + unit + commandcode + "02";
    }
  };
};
