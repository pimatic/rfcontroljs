module.exports = (helper) ->
  pulsesToBinaryMapping =
    '01': "0"
    '02': "1"
    '03': ""
  return protocolInfo = {
    name: "weather16"
    type: "weather"
    values:
      temperature:
        type: "number"
      humidity:
        type: "number"
      channel:
        type: "number"
      id:
        type: "number"
      lowBattery:
        type: "boolean"
    brands: ["Ea2 labs Bl999"]
    pulseLengths: [500, 1850, 3900, 9000]
    pulseCount: 74
    decodePulses: (pulses) ->
	  # pulses is something like: '02020202010202010101020101010201010101010201010101010101010102020102010203'
      # we first map: 01 => binary 0, 02 => binary 1, 03 => footer
      binary = helper.map(pulses, pulsesToBinaryMapping)
	  # binary is now something like: '111101100010001000001000000000110101'
	  # nibble:        T1     | |     T2    | |     T3    | |     T4    | |     T5
	  #  bit:      A0|A1|A2|A3| |B0|B1|B2|B3| |C0|C1|C2|C3| |D0|D1|D2|D3| |E0|E1|E2|E3
	  #            1 |1 |1 |1 | |0 |1 |1 |0 | |0 |0 |1 |0 | |0 |0 |1 |0 | |0 |0 |0 |0
	  #
	  #  nibble:        T6    | |     T7    | |     T8    | |     T9
	  #  bit:      F0|F1|F2|F3| |G0|G1|G2|G3| |H0|H1|H2|H3| |I0|I1|I2|I3
	  #            1 |0 |0 |0 | |0 |0 |0 |0 | |0 |0 |1 |1 | |0 |1 |0 |1
	  #
	  #	A0-A3,B2-B3 - ID
	  #	B0-B1 - Channel: 01 - 1, 10 - 2, 11 - 3
	  #	C0 - battery: 0 -  ok, 1 - low
	  #	C1-C3 - unknown
	  #	D0-F3 - temperature
	  #	G0-H3 - humidity
    #	I0-I3 - check sum
      return result = {
        id: helper.binaryToNumberLSBMSB(binary, 0, 7)
        channel: helper.binaryToNumber(binary, 4, 5)
        temperature: helper.binaryToSignedNumberLSBMSB(binary, 12, 23) / 10.0
        humidity: helper.binaryToSignedNumberLSBMSB(binary, 24, 31) + 100
        lowBattery: helper.binaryToNumberLSBMSB(binary, 8, 8) isnt 0
      }
  }
