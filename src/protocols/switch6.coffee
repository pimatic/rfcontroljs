module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0101': '1' #binary 1
    '1010': '1' #binary 1
    '0110': '0' #binary 0
    '02': ''    #footer
  }
  binaryToPulse = {
    '0': '0110'
    '1': '1010'
  }
  binaryToPulse2 = {
    '0': '0110'
    '1': '0101'
  }
  return protocolInfo = {
    name: 'switch6'
    type: 'switch'
    values:
      systemcode:
        type: "number"
      programcode:
        type: "number"
      state:
        type: "boolean"
    brands: ["Impuls"]
    pulseLengths: [150, 453, 4733]
    pulseCount: 50
    decodePulses: (pulses) ->
      # pulses is something like: '10010101101010010110010110101001010101011010101002'
      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '011100011011000111110000'
      # now we extract the temperature and humidity from that string
      # | 01110      | 01000       | 0              | 1
      # | SystemCode | ProgramCode | invertes state | state
      id5 = helper.binaryToNumber(binary, 0, 0)
      id4 = helper.binaryToNumber(binary, 1, 1)
      id3 = helper.binaryToNumber(binary, 2, 2)
      id2 = helper.binaryToNumber(binary, 3, 3)
      id1 = helper.binaryToNumber(binary, 4, 4)
      unitCode5 = helper.binaryToNumber(binary, 5, 5)
      unitCode4 = helper.binaryToNumber(binary, 6, 6)
      unitCode3 = helper.binaryToNumber(binary, 7, 7)
      unitCode2 = helper.binaryToNumber(binary, 8, 8)
      unitCode1 = helper.binaryToNumber(binary, 9, 9)
      state = helper.binaryToBoolean(binary, 11)
      id = 16 * id1 + 8 * id2 + 4 * id3 + 2 * id4 + id5
      unit = 16 * unitCode1 + 8 * unitCode2 + 4 * unitCode3 + 2 * unitCode4 + unitCode5
      return result = {
        systemcode: id
        programcode: unit
        state: state
      }
    encodeMessage: (message) ->
      systemcode1 = helper.numberToBinary(message.systemcode, 5)
      systemcode2= systemcode1[4]+systemcode1[3]+systemcode1[2]+systemcode1[1]+systemcode1[0]
      systemcode = helper.map(systemcode2, binaryToPulse)

      state = message.state
      programcode1 = helper.numberToBinary(message.programcode, 5)
      programcode2 = programcode1[4]+programcode1[3]+programcode1[2]+programcode1[1]+programcode1[0]
      programcode = helper.map(programcode2, binaryToPulse2)

      inverseState = (if state then binaryToPulse2['0'] else binaryToPulse2['1'])
      State = (if state then binaryToPulse2['1'] else binaryToPulse2['0'])
      return "#{systemcode}#{programcode}#{inverseState}#{State}02"
  }