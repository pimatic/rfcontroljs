module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '000022': ''
    '00': '0'
    '01': '1'
    '03': ''
  }
  binaryToPulse = {
    '0': '00'
    '1': '01'
  }
  return protocolInfo = {
    name: 'switch31'
    type: 'switch'
    values:
      id:
        type: "number"
      channel:
        type: "number"
      state:
        type: "boolean"
      all:
        type: "boolean"
    brands: [ "Masterplug UK" ]
    pulseLengths: [ 452, 1336, 3392, 10124 ]
    pulseCount: 88
    decodePulses: (pulses) ->
      # Pulses are something like:
      # 0000220100010101000000010101000001000100010000000101010000000101000100010000000001010103

      # We first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      # Binary is now something like:
      # 1011100011100101010001110001101010000111
      # <              ><              ><  ><  >
      # First segment is the id
      # Second segment is the inverted id
      # Third segment is the reverse channel
      # Fourth segment is the inverted reverse channel
      # Also the last bit of the binary sequence is the state

      # Get the first 16 bits and convert to a number
      id = helper.binaryToNumber(binary, 0, 15)

      # Validate the id with the 2nd 2 bytes which contains the inverted id
      if id != (helper.binaryToNumber(binary, 16, 31) ^ 0xffff)
        console.error "ID validation failed"
        return false

      # Get the 33 till 36th bits to calculate the channel
      channel = binary.substr(32, 4)

      # Validate the channel with the last 4 bits which contains the inverted channel
      if helper.binaryToNumber(channel, 0, 3) != (helper.binaryToNumber(binary, 36, 39) ^ 0xf)
        console.error "Channel validation failed"
        return false

      # Reverse the channel bits
      channel = helper.reverse(channel)
      # Convert bits to number
      channel = helper.binaryToNumber(channel, 0, 3)

      # get the last bit of the sequence for the on/off state
      state = helper.binaryToBoolean(binary, 39)

      # If this is an off signal, inverse the channel
      if state == false
        channel = channel ^ 0xf

      # If the channel number is 5 it's all channels on
      all = false
      if channel == 5
        all = true

      # Return the decoded pulses
      return result = {
        id: id
        channel: channel
        state: state
        all: all
      }

    encodeMessage: (message) ->
      id = message.id
      # Bit shift the id 16 positions to the left and add the inverted id
      id = (id << 16) + (id ^ 0xffff)
      # Convert the number to a binary string
      id = helper.numberToBinary(id, 32)
      # Convert the binary string to pulses
      id = helper.map(id, binaryToPulse)

      # If the message is for all channels override the channel to channel 5
      channel = message.channel
      if message.all == true
        channel = 5

      # If this is an off signal, inverse the channel
      if message.state == false
        channel = channel ^ 0xf

      # Bit shift the inverted channel 4 positions to the left and add the channel
      # The channel is still in reverse order, that's why the left part of the
      # channel needs to be inverted and not the right part
      channel = ((channel ^ 0xff) << 4) + channel
      # Convert the number to a binary string
      channel = helper.numberToBinary(channel, 8)
      # Only now we can reverse the bits
      channel = helper.reverse(channel)
      # Convert the binary string to pulses
      channel = helper.map(channel, binaryToPulse)

      # Return the encoded message
      return "000022#{id}#{channel}03"
  }
