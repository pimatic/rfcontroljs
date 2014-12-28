module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '01': "0",
    '02': "1",
    '03': ""
  };
  return protocolInfo = {
    name: "weather6",
    type: "weather",
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
    brands: ["Sempre (Aldi) GT-WT-02"],
    pulseLengths: [552, 2089, 4137, 9032],
    pulseCount: 80,
    decodePulses: function(pulses) {

      /*
      Bits:      |0 0 0 0 0 0 0 0 |0 0 1 1 |1 1 1 1 1 1 1 1 2 2 2 2 |2 2 2 2 2 2 3 |3 3 3 3 3 3 |  |3 |  |
                 |0 1 2 3 4 5 6 7 |8 9 0 1 |2 3 4 5 6 7 8 9 0 1 2 3 |4 5 6 7 8 9 0 |1 2 3 4 5 6 |  |7 |  |
      Pulse like:|0102010201020202|01010101|010101010102010202010201|02010102020101|020102020101|03|01|03|
                 |01010111        |0000    |000001011010            |1001100       |101100      |  |0 |  |
                 |Id              |Ch ?    |Temperature             |Humidity      |?           |  |? |  |
                 |87              |        |90 (9.0)                |76            |            |  |  |  |
       */
      var battery, binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      battery = helper.binaryToNumber(binary, 37, 37);
      if (battery === 1) {
        battery = "Good";
      } else {
        battery = "Bad";
      }
      return result = {
        id: helper.binaryToNumber(binary, 0, 7),
        channel: helper.binaryToNumber(binary, 8, 9) + 1,
        temperature: helper.binaryToSignedNumber(binary, 12, 23) / 10,
        humidity: helper.binaryToNumber(binary, 24, 30),
        battery: battery
      };
    }
  };
};
