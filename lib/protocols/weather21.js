module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '12222222': '',
    '12': '0',
    '22': '1',
    '20': '1',
    '21': '1',
    '13': ''
  };
  return protocolInfo = {
    name: 'weather21',
    type: 'weather',
    values: {
      temperature: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      id: {
        type: "number"
      },
      lowBattery: {
        type: "boolean"
      }
    },
    brands: ["Auriol HG02832"],
    pulseLengths: [196, 288, 628, 61284],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, lowBattery, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      console.log(pulses, "\n", binary);
      lowBattery = !helper.binaryToBoolean(binary, 8);
      return result = {
        bits: binary,
        id: helper.binaryToNumberLSBMSB(binary, 0, 7),
        channel: helper.binaryToNumberMSBLSB(binary, 0, 7),
        temperature: helper.binaryToNumberMSBLSB(binary, 16, 23),
        humidity: helper.binaryToNumberMSBLSB(binary, 12, 19),
        lowBattery: lowBattery
      };
    }
  };
};
