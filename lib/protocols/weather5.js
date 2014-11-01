module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': '0',
    '02': '1',
    '03': ''
  };
  return protocolInfo = {
    name: 'weather5',
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
      battery: {
        type: "number"
      },
      avgAirspeed: {
        type: "number"
      },
      windGust: {
        type: "number"
      },
      windDirection: {
        type: "number"
      },
      rain: {
        type: "number"
      }
    },
    brands: ["Auriol", "Ventus", "Hama", "Meteoscan", "Alecto", "Balance"],
    pulseLengths: [534, 959, 1951, 9000],
    pulseCount: 74,
    decodePulses: function(pulses) {
      var avgAirspeed, battery, binary, h0, h1, humidity, id, rain, result, states, substate, temperature, windDirection, windGust;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      states = helper.binaryToNumber(binary, 9, 10, 'LSB-MSB');
      id = helper.binaryToNumber(binary, 0, 7, 'LSB-MSB');
      battery = 1 - helper.binaryToNumber(binary, 8, 8);
      if (states === 0 || states === 1 || states === 2) {
        temperature = helper.binaryToNumberSigned(binary, 12, 23, 'LSB-MSB') / 10.0;
        h0 = helper.binaryToNumber(binary, 28, 31, 'LSB-MSB');
        h1 = helper.binaryToNumber(binary, 24, 27, 'LSB-MSB');
        humidity = h0 * 10 + h1;
        return result = {
          id: id,
          battery: battery,
          temperature: temperature,
          humidity: humidity
        };
      } else if (states === 3) {
        substate = helper.binaryToNumber(binary, 12, 14, 'LSB-MSB');
        if (substate === 1) {
          avgAirspeed = helper.binaryToNumber(binary, 24, 31, 'LSB-MSB') / 5.0;
          return result = {
            id: id,
            battery: battery,
            avgAirspeed: avgAirspeed
          };
        } else if (substate === 7) {
          windDirection = helper.binaryToNumber(binary, 15, 23, 'LSB-MSB');
          windGust = helper.binaryToNumber(binary, 15, 23, 'LSB-MSB') / 5.0;
          return result = {
            id: id,
            battery: battery,
            windDirection: windDirection,
            windGust: windGust
          };
        } else if (substate === 3) {
          rain = helper.binaryToNumber(binary, 16, 31, 'LSB-MSB') / 4.0;
          return result = {
            id: id,
            battery: battery,
            rain: rain
          };
        }
      }
      return result = {
        id: id,
        battery: battery
      };
    }
  };
};
