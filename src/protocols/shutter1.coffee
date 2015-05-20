module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '32': '' #header
    '01': '0' #binary 0
    '10': '1' #binary 1
    '14': ''  #footer
  }
  binaryToPulse = {
    '0': '01'
    '1': '10'
  }
  return protocolInfo = {
    name: 'shutter1'
    type: 'switch'
    values:
      id:
        type: "number"
      state:
        type: "boolean"
    brands: ["Nobily"]
    pulseLengths: [280, 736, 1532, 4752, 7796]
    pulseCounts: 168
    decodePulses: (pulses) ->
      # pulses for up and down are something like:
      #32
      #01011001010101100101010101010110011010100101101010010110010101
      #10010101
      #10010101
      #10
      #32
      #01011001010101100101010101010110011010100101101010010110010101
      #10010101
      #10010101
      #14

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # binary is now something like: '0010000100000001011100111001000     10011001'
      # now we extract the data from that string
      # | 0010000100000001011100111001000 | 1000  | 1000  |
      # | ID                              | state | state |
      #
      # | 1     |
      # | fixed |
      #
      # | 0010000100000001011100111001000 | 1000  | 1000  |
      # | ID                              | state | state |

      state_binary = binary[31..34]
      switch state_binary
        when "1001" then state_boolean = false
        when "1000" then state_boolean = true
      return result= {
        id: helper.binaryToNumber(binary, 0, 30)
        state: state_boolean
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 31), binaryToPulse)
      switch message.state
        when false then state_binary = "1001"
        when true then state_binary = "1000"
      state_pulse = helper.map(state_binary, binaryToPulse)
      return "32#{id}#{state_pulse}#{state_pulse}1032#{id}#{state_pulse}#{state_pulse}14"
  }
