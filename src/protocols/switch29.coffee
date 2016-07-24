module.exports = function(helper) {
  var binaryToPulse, protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '10': '1',
    '01': '0',
    '02': ''
  };
  binaryToPulse = {
    '0': '01',
    '1': '10'
  };
  return protocolInfo = {
    name: 'switch-conrad',
    type: 'switch',
    values: {
      unit: {
        type: "number"
      },
      id: {
        type: "number"
      },
      remoteid: {
        type: "number",
	default: 2275840
      },
      state: {
        type: "boolean"
      }
    },
    brands: ["Conrad RSL"],
    pulseLengths: [650, 1450, 6868],
    pulseCount: 32,
    decodePulses: function(pulses) {
      var binary, result;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      return result = {
        unitCode: helper.binaryToNumber(binary, 25, 28),
        state: helper.binaryToBoolean(binary, 29)
      };
    },
    encodeMessage: function(message) {
      var remoteID, onPulse, newUnitCode, offPulse, prefix, state, unitCode;
      prefix = "1001";

if (message.remoteid == null) { remoteID=2275840; } 
else { remoteID = message.remoteid; }

remoteID = helper.map(helper.numberToBinary(remoteID, 24), binaryToPulse);

if (message.unit == 1) { newUnitCode=3; }
if (message.unit == 2) { newUnitCode=0; }
if (message.unit == 3) { newUnitCode=2; }
if (message.unit == 4) { newUnitCode=1; }

if (message.id == 1) {
	onPulse = "01101001";
	offPulse = "10101001";
}
if (message.id == 2) {
	onPulse = "10010110";
	offPulse = "01100110";
}
if (message.id == 3) {
	onPulse = "01010101";
	offPulse = "1001010101";
}
if (message.id == 4) {
	onPulse = "01011001";
	offPulse = "10011001";
}
      unitCode = helper.map(helper.numberToBinary(newUnitCode, 2), binaryToPulse);
      state = (message.state ? onPulse : offPulse);
      return "" + prefix + unitCode + state + remoteID + "02";
    }
  };
};
