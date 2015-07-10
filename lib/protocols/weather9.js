module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather9',
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
      sync: {
        type: "number"
      },
      id: {
        type: "number"
      },
      lowBattery: {
        type: "boolean"
      }
    },
    brands: ["TCM"],
    pulseLengths: [412, 2075, 4115, 8070],
    pulseCount: 86,
    decodePulses: function(pulses) {
      var binary, h0, h1, humidity, lowBattery, result, sync, t0, t1, t2, temperature;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      lowBattery = helper.binaryToBoolean(binary, 34);
      sync = helper.binaryToBoolean(binary, 35);
      t0 = helper.binaryToNumber(binary, 22, 25);
      t1 = helper.binaryToNumber(binary, 18, 21);
      t2 = helper.binaryToNumber(binary, 14, 17);
      temperature = Math.round(((t0 * 256 + t1 * 16 + t2) * 10 - 12200) / 18) / 10;
      h0 = helper.binaryToNumber(binary, 30, 33);
      h1 = helper.binaryToNumber(binary, 26, 29);
      humidity = h0 * 16 + h1;
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 12, 13) + 1,
        temperature: temperature,
        humidity: humidity,
        lowBattery: lowBattery,
        sync: sync
      };
    }
  };
};
