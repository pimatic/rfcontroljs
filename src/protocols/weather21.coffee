module.exports = (helper) ->
  # as the mappings overlap we need
  # maintain the order of mappings,
  # as map function will apply first match
  pulsesToBinaryMapping = [
    {'12222222': '' } #header
    {'02': '0' } #binary 0 - TODO need sample data
    {'12': '0' } #binary 0
    {'22': '1' } #binary 0
    {'20': '1' } #binary 1
    {'21': '1' } #binary 1
    {'03': '' }  #footer - TODO check if 03 only occurs at the end of pulse
    {'13': '' }  #footer
    {'23': '' }  #footer
  ]
  # create table for CRC-8
  crcTable = helper.generateCrc8Table(0x31)

  return protocolInfo = {
    name: 'weather21'
    type: 'weather'
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
    brands: ["Auriol HG02832"]
    pulseLengths: [196, 288, 628, 61284]
    pulseCount: 88
    decodePulses: (pulses) ->
      # map pulses to binary sequence
      binary = helper.map(pulses, pulsesToBinaryMapping)

      # binary (40 bits) is something like: '101000010100100000000000101100111000100'
      # now we extract the temperature and humidity from that string
      # | 0-----7   | 8----15 | 16-19 | 20----31     | 32----39 |
      # | 10100001 | 01001000 | 0000  | 000010110011 | 1000100  |
      # |    ID    | Humidity | Flags | Temperature  | Checksum |
      # Flags
      # 16: Low Battery indicator 1 = normal, 0 = low
      # 17: TX-Button
      # 18-19: Channel (value +1)
      digest = [helper.binaryToOctets(binary,32).reduce (a,b) -> (a ^ b) % 256]
      crcValue = helper.binaryToNumber(binary, 32, 39)
      return result = {
        crcOk: crcValue is helper.crc8(crcTable, digest, 0x53)
        id: helper.binaryToNumber(binary, 0, 7)
        humidity: helper.binaryToNumber(binary, 8, 15)
        lowBattery: helper.binaryToBoolean(binary, 16)
        channel: helper.binaryToNumber(binary, 18, 19) + 1
        temperature: helper.binaryToSignedNumber(binary, 20, 31) / 10
      }
  }
