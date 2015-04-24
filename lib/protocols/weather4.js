module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '1111111104': '',
    '02': '0',
    '03': '1',
    '05': ''
  };
  return protocolInfo = {
    name: 'weather4',
    type: 'weather',
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      temperature: {
        type: "number"
      },
      humidity: {
        type: "number"
      },
      lowBattery: {
        type: "boolean"
      }
    },
    brands: ["Auriol"],
    pulseLengths: [526, 990, 1903, 4130, 7828, 16076],
    pulseCount: 92,
    decodePulses: function(pulses) {
      var binary, h0, h1, humidity, lowBattery, result, t0, temperature;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      t0 = helper.binaryToNumber(binary, 16, 27);
      temperature = Math.round((t0 * 10 - 12200) / 18) / 10;
      h0 = helper.binaryToNumber(binary, 28, 31);
      h1 = helper.binaryToNumber(binary, 32, 35);
      humidity = h0 * 10 + h1;
      if ((3 - (helper.binaryToNumber(binary, 12, 15) / 10)) < 2.5) {
        lowBattery = true;
      } else {
        lowBattery = false;
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 36, 39),
        temperature: temperature,
        humidity: humidity,
        lowBattery: lowBattery
      };
    }
  };
};
