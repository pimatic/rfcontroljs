module.exports = function(helper) {
  var protocolInfo;
  return protocolInfo = {
    name: 'rawswitch',
    type: 'switch',
    values: {
      pulseCount: {
        type: "number"
      },
      pulseLengths: {
        type: "object"
      },
      pulsesOn: {
        type: "string"
      },
      pulsesOff: {
        type: "string"
      }
    },
    brands: ["RAW"],
    pulseLengths: [],
    pulseCount: 0,
    decodePulses: function(pulses) {
      return null;
    },
    encodeMessage: function(message) {
      var pulses;
      this.pulseLengths = message.pulseLengths;
      pulses = (message.state ? message.pulsesOn : message.pulsesOff);
      return pulses;
    }
  };
};
