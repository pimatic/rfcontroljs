module.exports = function(helper) {
  var protocolInfo, pulsesToBinaryMapping;
  pulsesToBinaryMapping = {
    '11': '0',
    '01': '1',
    '02': '',
	'12': ''
  };
  return protocolInfo = {
    name: 'weather17',
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
      }
    },
    brands: ["tfa30.3125"],
    pulseLengths: [444, 1160, 28580],
    pulseCount: 88,
    decodePulses: function(pulses) {
      var binary, h0, h1, humidity, result, t0, t1, t2, temperature;
      binary = helper.map(pulses, pulsesToBinaryMapping);
      t0 = helper.binaryToNumber(binary, 20, 23);				//Zehnerstelle bei Temperatur müssen 5 abgezogen werden , bei Humidity nix abziehen !
      t1 = helper.binaryToNumber(binary, 24, 27);				//Einerstelle Temp / Hum
      t2 = helper.binaryToNumber(binary, 28, 31);				//Dezimalstelle nur fuer Temp
      temperature = (((t0-5) * 10)+t1+(t2*0.1));				//Temperatur t0 ist Zehnerstelle minus 5 
	  h0 = helper.binaryToNumber(binary, 20, 23);				//Kopie der Zehnerstelle bei Temperatur müssen 5 abgezogen werden , bei Humidity nix abziehen !
      h1 = helper.binaryToNumber(binary, 24, 27);				//Kopie der Einerstelle Temp / Hum
      humidity = h0 * 10 + h1;									//Humidity aus Kopie der Daten ermitteln
      channel = helper.binaryToNumber(binary, 8, 10) ;  		//Temp = 000 , Humidity = 111 ! entsprechend wird entweder temperature oder humidty zurueck gemeldet !
      if (channel === 0 ) {
		  return result = {
        id: helper.binaryToNumber(binary, 12, 18),  			//wechselt bei jedem Batteriewechsel !
        channel: channel ,  									//Temp = 000 , Humidity = 111 (Dezimal = 7) !
        temperature: temperature								//channel = 7 , Humidty wird zurueck gemeldet
      };
	}
	else{
		return result = {
        id: helper.binaryToNumber(binary, 12, 18),  			//wechselt bei jedem Batteriewechsel !
        channel: channel ,  									//Temp = 000 , Humidity = 111 !
        humidity: humidity										//channel = 7 , Humidty wird zurueck gemeldet
      };	  
    };
   }
  };
};
