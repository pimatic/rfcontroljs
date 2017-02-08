module.exports = function(helper) {
  var protocolInfo;
  return protocolInfo = {
    name: 'rawshutter',
    type: 'command',
    commands: ["up", "down", "stop"],
    values: {
      pulseCount: {
        type: "number"
      },
      pulseLengths: {
        type: "object"
      },
      pulsesUp: {
        type: "string"
      },
      pulsesDown: {
        type: "string"
      },
      pulsesStop: {
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
      pulses = ((function() {
        switch (message.command) {
          case void 0:
            return '';
          case 'up':
            return message.pulsesUp;
          case 'down':
            return message.pulsesDown;
          case 'stop':
            return message.pulsesStop;
        }
      })());
      return pulses;
    }
  };
};
