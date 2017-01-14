module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  binaryToPulse = {
    '1': '02',
    '0': '01'
  };
  return protocolInfo = {
    name: 'weather13',
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
    brands: ["Xiron Temperature & Humidity Sensor 2"],
    pulseLengths: [492, 992, 2028, 4012],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, lowBattery, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      lowBattery = !helper.binaryToBoolean(binary, 8);
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 10, 11) + 1,
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10,
        humidity: helper.binaryToNumber(binary, 28, 35),
        lowBattery: lowBattery
      };
    },
    encodeMessage: function(message) {
      var channel, humidity, id, lowBattery, temperature;
      id = helper.numberToBinary(message.id, 8);
      lowBattery = message.lowBattery ? 0 : 1;
      channel = helper.numberToBinary(message.channel - 1, 2);
      temperature = helper.numberToBinary(message.temperature * 10, 12);
      humidity = helper.numberToBinary(message.humidity, 8);
      return helper.map("" + id + lowBattery + "0" + channel + temperature + "1111" + humidity, binaryToPulse) + "03";
    }
  };
};
