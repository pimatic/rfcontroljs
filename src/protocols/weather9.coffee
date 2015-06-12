module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '01': '0' #binary 0
    '02': '1' #binary 1
    '03': ''  #footer
  }
  return protocolInfo = {
    name: 'weather9'
    type: 'weather'
    values:
      temperature:
        type: "number"
      humidity:
        type: "number"
      channel:
        type: "number"
	  Sync:
		type: "number"
      id:
        type: "number"
      lowBattery:
        type: "boolean"
    brands: ["TCM"]
    pulseLengths: [412, 2075, 4115, 8070]
    pulseCount: 86
    decodePulses: (pulses) ->
      # pulses is something like: '01020102020201020101010101010102010101010202020101020202010102010101020103'
      # we first map the pulse sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '010111010000000100001110011100100010'
      # now we extract the temperature and humidity from that string
      # TCM | 01011000 | 11 |  01   |  11   | 000100001001 | 00111101 |  0  |  0   |  10  |   1001    | ''
      # TCM |    ID    |  ? |   ?   |Channel|     Temp.    | Humid.   | Bat | Sync |  ?   | Prüfsumme | Footer
      lowBattery = helper.binaryToBoolean(binary, 34)
	  Sync = helper.binaryToBoolean(binary, 35)
	     t0 = helper.binaryToNumber(binary, 22, 25)
         t1 = helper.binaryToNumber(binary, 18, 21)
         t2 = helper.binaryToNumber(binary, 14, 17)
        temperature = Math.round(((t0 * 256 + t1 * 16 + t2) * 10 - 12200) / 18 ) / 10
         h0 = helper.binaryToNumber(binary, 30, 33)
         h1 = helper.binaryToNumber(binary, 26, 29)
        humidity = h0 * 16 + h1
      return result = {
        id: helper.binaryToNumber(binary, 0, 7)
        channel: helper.binaryToNumber(binary, 12, 13) + 1
        temperature: temperature
        humidity: humidity
        lowBattery: lowBattery
		Sync: Sync
      }
  }
