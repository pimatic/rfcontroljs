module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '1',
    '10': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '10',
    '1': '01'
  };
  return protocolInfo = {
    name: 'doorbell1',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      unit: {
        type: "number"
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["ADEO", "ELRO/Home Easy HE-852"],
    pulseLengths: [217, 648, 6696],
    pulseCount: 50,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        id: helper.binaryToNumberLSBMSB(binary, 0, 11),
        unit: helper.binaryToNumberLSBMSB(binary, 12, 22),
        state: !helper.binaryToBoolean(binary, 23)
      };
    },
    encodeMessage: function(message) {
      var id, state, unit;
      id = helper.map(helper.numberToBinaryLSBMSB(message.id, 12), binaryToPulse);
      unit = helper.map(helper.numberToBinaryLSBMSB(message.unit, 11), binaryToPulse);
      state = (message.state ? binaryToPulse['0'] : binaryToPulse['1']);
      return "" + id + unit + state + "02";
    }
  };
};
