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
      humidity: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      id: {
        type: "number"
      },
      battery: {
        type: "string"
      }
    },
    brands: ["Auriol"],
    pulseLengths: [456, 1990, 3940, 9236],
    pulseCount: 66,
    decodePulses: function(pulses) {
      var battery, binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      battery = helper.binaryToBoolean(binary, 8);
      if (battery === true) {
        battery = "Good";
      } else {
        battery = "Bad";
      }
      return result = {
        id: helper.binaryToNumberMSBLSB(binary, 0, 7),
        channel: helper.binaryToNumberMSBLSB(binary, 10, 11),
        temperature: helper.binaryToSignedNumberMSBLSB(binary, 12, 23) / 10,
        battery: battery
      };
    }
  };
};
