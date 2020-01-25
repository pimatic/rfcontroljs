module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = [
    {
      '12222222': ''
    }, {
      '12': '0'
    }, {
      '22': '1'
    }, {
      '20': '1'
    }, {
      '21': '1'
    }, {
      '13': ''
    }, {
      '23': ''
    }
  ];
  return protocolInfo = {
    name: 'weather21',
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
      lowBattery: {
        type: "boolean"
      }
    },
    brands: ["Auriol HG02832"],
    pulseLengths: [196, 288, 628, 61284],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, flags, lowBattery, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      console.log(pulses, "\n", binary);
      lowBattery = !helper.binaryToBoolean(binary, 8);
      flags = helper.binaryToNumberMSBLSB(binary, 16, 19);
      return result = {
        id: helper.binaryToNumberMSBLSB(binary, 0, 7),
        channel: helper.binaryToNumberMSBLSB(binary, 18, 19) + 1,
        temperature: helper.binaryToSignedNumberMSBLSB(binary, 20, 31) / 10,
        humidity: helper.binaryToNumberMSBLSB(binary, 8, 15),
        lowBattery: helper.binaryToBoolean(binary, 8)
      };
    }
  };
};
