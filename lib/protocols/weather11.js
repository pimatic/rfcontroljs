module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather11',
    type: 'weather',
    values: {
      id: {
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
    brands: ["Conrad"],
    pulseLengths: [480, 1960, 3900, 9200],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var binary, h0, h1, humidity, id, lowBattery, result, states, substate, temperature;
      
      binary = helper.map(pulses, pulsesToBinaryMapping);
      states = helper.binaryToNumberLSBMSB(binary, 9, 10);

      id = helper.binaryToNumberLSBMSB(binary, 0, 7);
      lowBattery = helper.binaryToNumberLSBMSB(binary, 8, 8) !== 0;
      if (states === 0 || states === 1 || states === 2) {
        temperature = helper.binaryToSignedNumberLSBMSB(binary, 12, 23) / 10.0;
        humidity = helper.binaryToSignedNumberLSBMSB(binary, 24, 31) + 100;
        return result = {
          id: id,
          lowBattery: lowBattery,
          temperature: temperature,
          humidity: humidity
        };
      } 
      return result = {
        id: id,
        lowBattery: lowBattery
      };
    }
  };
};
