module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather14',
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
    brands: ["Prologue Temperature & Humidity Sensor"],
    pulseLengths: [480, 1960, 3908, 8784],
    pulseCount: 76,
    decodePulses: function(pulses) {
      var binary, humidity, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      result = {
        id: helper.binaryToNumber(binary, 4, 11),
        channel: helper.binaryToNumberLSBMSB(binary, 12, 13) + 1,
        temperature: helper.binaryToSignedNumber(binary, 16, 27) / 10,
        lowBattery: !helper.binaryToBoolean(binary, 15)
      };
      humidity = helper.binaryToNumber(binary, 28, 35);
      if (humidity !== 204) {
        result.humidity = humidity;
      }
      return result;
    }
  };
};
