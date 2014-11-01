module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': '' #footer
  }
  return protocolInfo = {
    name: 'weather5'
    type: 'weather'
    values:
      id:
        type: "number"
      temperature:
        type: "number"
      humidity:
        type: "number"
      battery:
        type: "number"
      avgAirspeed:
        type: "number"
      windGust:
        type: "number"
      windDirection:
        type: "number"
      rain:
        type: "number"
    brands: ["Auriol", "Ventus", "Hama", "Meteoscan", "Alecto", "Balance"]
    pulseLengths:  [ 534, 959, 1951, 9000 ]
    pulseCount: 74
    decodePulses: (pulses) ->
      #Supportet stations
      #- Auriol H13726
      #- Ventus WS155
      #- Hama EWS 1500
      #- Meteoscan W155/W160
      #- Alecto WS4500
      #- Alecto WS3500
      #- Ventus W044
      #- Balance RF-WS105
      #
      # pulses could be:
      # '01020101010201020102010101020202020202010101010102020201010202010202020203'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '01000101 0100 011111100000 11100110 1111'
      # based on this example : T12,6 H65
      # 01000101 0100 011111100000 11100110 1111
      # 01000101 : Station ID (random after restart)
      # 0100 : states
      # 01111110000011100110 : data
      # 1111 : check sum (n8 = ( 0xf - n0 - n1 - n2 - n3 - n4 - n5 - n6 - n7) & 0xf)
      # the states showing which data is transmitted
      # 0  1  0  0
      # |  |  |  |-> 0: Scheduled transmission.
      # |  |  |  |-> 1: The transmission was initiated by pressing the button inside the sensor unit
      # |  |--|----> 00,01,10: Temperatur and Humidity is transmitted. 11: Non temp/hum data
      # |----------> 0: Sensor's battery voltage is normal. 1: Battery voltage is below ~2.6 V.
      #
      states = helper.binaryToNumberLSBMSB(binary, 9, 10)
      #temprature and humidity
      id = helper.binaryToNumberLSBMSB(binary, 0, 7)
      battery = 1 - helper.binaryToNumberLSBMSB(binary, 8, 8)
      if (states is 0 or states is 1 or states is 2)
        temperature = helper.binaryToSignedNumberLSBMSB(binary, 12, 23) / 10.0
        h0 = helper.binaryToNumberLSBMSB(binary, 28, 31)
        h1 = helper.binaryToNumberLSBMSB(binary, 24, 27)
        humidity = h0 * 10 + h1
        return result = {
          id: id
          battery : battery
          temperature: temperature
          humidity: humidity
        }
      else if states is 3
        substate = helper.binaryToNumberLSBMSB(binary, 12, 14)
        if substate is 1
          avgAirspeed = helper.binaryToNumberLSBMSB(binary, 24, 31) / 5.0
          return result = {
            id: id
            battery : battery
            avgAirspeed: avgAirspeed
          }
        else if substate is 7
          windDirection = helper.binaryToNumberLSBMSB(binary, 15, 23)
          windGust = helper.binaryToNumberLSBMSB(binary, 15, 23) / 5.0
          return result = {
            id: id
            battery : battery
            windDirection: windDirection
            windGust: windGust
          }
        else if substate is 3
          rain = helper.binaryToNumberLSBMSB(binary, 16, 31) / 4.0
          return result = {
            id: id
            battery : battery
            rain: rain
          }
      return result = {
        id: id
        battery : battery
      }
  }
