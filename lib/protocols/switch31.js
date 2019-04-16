var reverse;

reverse = function(s) {
  if (s.length < 2) {
    return s;
  } else {
    return reverse(s.slice(1)) + s[0];
  }
};

module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '000022': '',
    '00': '0',
    '01': '1',
    '03': ''
  };
  binaryToPulse = {
    '0': '00',
    '1': '01'
  };
  return protocolInfo = {
    name: 'switch31',
    type: 'switch',
    values: {
      id: {
        type: "number"
      },
      channel: {
        type: "number"
      },
      state: {
        type: "boolean"
      },
      all: {
        type: "boolean"
      }
    },
    brands: ["Masterplug UK"],
    pulseLengths: [452, 1336, 3392, 10124],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var all, binary, channel, id, result, state;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      id = helper.binaryToNumber(binary, 0, 15);
      if (id !== (helper.binaryToNumber(binary, 16, 31) ^ 0xffff)) {
        console.error("ID validation failed");
        return false;
      }
      channel = binary.substr(32, 4);
      if (helper.binaryToNumber(channel, 0, 3) !== (helper.binaryToNumber(binary, 36, 39) ^ 0xf)) {
        console.error("Channel validation failed");
        return false;
      }
      channel = reverse(channel);
      channel = helper.binaryToNumber(channel, 0, 3);
      state = helper.binaryToBoolean(binary, 39);
      if (state === false) {
        channel = channel ^ 0xf;
      }
      all = false;
      if (channel === 5) {
        all = true;
      }
      return result = {
        id: id,
        channel: channel,
        state: state,
        all: all
      };
    },
    encodeMessage: function(message) {
      var channel, id;
      id = message.id;
      id = (id << 16) + (id ^ 0xffff);
      id = helper.numberToBinary(id, 32);
      id = helper.map(id, binaryToPulse);
      channel = message.channel;
      if (message.all === true) {
        channel = 5;
      }
      if (message.state === false) {
        channel = channel ^ 0xf;
      }
      channel = ((channel ^ 0xff) << 4) + channel;
      channel = helper.numberToBinary(channel, 8);
      channel = reverse(channel);
      channel = helper.map(channel, binaryToPulse);
      return "000022" + id + channel + "03";
    }
  };
};
