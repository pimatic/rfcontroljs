module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather7',
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
    brands: ["Auriol IAN 9183"],
    pulseLengths: [456, 1990, 3940, 9236],
    pulseCount: 66,
    decodePulses: function(pulses) {
      var binary, lowBattery, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      lowBattery = !helper.binaryToBoolean(binary, 8);
      return result = {
        id: helper.binaryToNumberMSBLSB(binary, 0, 7),
        channel: helper.binaryToNumberMSBLSB(binary, 10, 11),
        temperature: helper.binaryToSignedNumberMSBLSB(binary, 12, 23) / 10,
        humidity: helper.binaryToNumberMSBLSB(binary, 24, 29),
        lowBattery: lowBattery
      };
    }
  };
};
