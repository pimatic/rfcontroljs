module.exports = (helper) ->
  pulsesToBinaryMapping = {
    '0': '0' #binary 0
    '1': '1' #binary 1
    '2': ''  #footer
  }
  binaryToPulse = {
    '0': '0'
    '1': '1'
  }
  return protocolInfo = {
    name: 'switch29'
    type: 'switch'
    commands: ["arm", "disarm", "home", "panic", "grp1", "grp2", "grp3"]
    values:
      id:
        type: "number"
      unit:
        type: "number"
      command:
        type: "number"
    brands: ["Meiantech", "Atlantic", "Aidebao", "PB-403R"] # Wireless Keychain Remote Control type: PB-403R
    pulseLengths: [ 404, 804, 4028 ]
    pulseCount: 74
    decodePulses: (pulses) ->
      # message example
      # 00101011101010101101001010101010111000110010101010101011001011001010110012
      # 0010101110101010110100101010101011100011001010101 011001010101100101101010 2 arm
      # 0010101110101010110100101010101011100011001010101 010101100101100101011001 2 panic
      # 0010101110101010110100101010101011100011001010101 100101010101100110011010 2 disarm
      # 0010101110101010110100101010101011100011001010101 010110010101100101010110 2 home
      # 0010101110101010110100101010101011100011001010101 101001010101100110101010 2 grp1
      # 0010101110101010110100101010101011100011001010101 100110010101100110010110 2 grp2
      # 0010101110101010110100101010101011100011001010101 101010010101100110100110 2 grp3
      #| 0010101110101010110100101 | 010101011100011001010101 | 010101100101100101011001 | 2
      #| id (25)                   | unit(24)                 | command(24)              | footer (1)

      # we first map the sequences to binary
      binary = helper.map(pulses, pulsesToBinaryMapping)
      id = helper.binaryToNumber(binary, 0, 24)
      unit = helper.binaryToNumber(binary, 25, 48)
      command = helper.binaryToNumber(binary, 49, 72)
      commandcode = pulses[49..72]
      switch commandcode
        when "011001010101100101101010" then command = "arm"
        when "010101100101100101011001" then command = "panic"
        when "100101010101100110011010" then command = "disarm"
        when "010110010101100101010110" then command = "home"
        when "101001010101100110101010" then command = "grp1"
        when "100110010101100110010110" then command = "grp2"
        when "101010010101100110100110" then command = "grp3"
      return result= {
        id: id,
        unit: unit,
        command: command
      }

    encodeMessage: (message) ->
      id = helper.map(helper.numberToBinary(message.id, 25), binaryToPulse)
      unit = helper.map(helper.numberToBinary(message.unit, 24), binaryToPulse)
      switch message.command
        when "arm"    then commandcode = "011001010101100101101010"
        when "panic"  then commandcode = "010101100101100101011001"
        when "disarm" then commandcode = "100101010101100110011010"
        when "home"   then commandcode = "010110010101100101010110"
        when "grp1"   then commandcode = "101001010101100110101010"
        when "grp2"   then commandcode = "100110010101100110010110"
        when "grp3"   then commandcode = "101010010101100110100110"
      return "#{id}#{unit}#{commandcode}2"
  }
