class ParsingError extends Error
  constructor: (@message,@cause)->
    Error.captureStackTrace(this, ParsingError)

module.exports = {
  ParsingError: ParsingError
  map: (data, mapping) ->
    i = 0
    result = ''

    if not Array.isArray mapping
      while i < data.length
        hadMatch = false
        # try each mapping rule
        for search, replace of mapping
          # if we have enough data left
          if data.length-i >= search.length
            # and rule matches
            if data.substr(i, search.length) is search
              # add replace to result
              result += replace
              i += search.length
              hadMatch = true
              break
        unless hadMatch then throw new ParsingError("Data did not match mapping")
    else
      while i < data.length
        hadMatch = false
        for s in mapping
          search = Object.keys(s)[0]
          replace = s[search]
          if data.length-i >= search.length
            if data.substr(i, search.length) is search
              result += replace
              i += search.length
              hadMatch = true
              break
        unless hadMatch then throw new ParsingError("Data did not match mapping")
    return result

  mapByArray: (data, mapping) ->
    result = ''
    for d in data
      result += mapping[parseInt(d, 10)]
    return result

  # converts the binary data to a singed number.
  binaryToSignedNumberMSBLSB: (data, b, e) ->
    signedPos = b
    b++ #increment b to remove the sign bit from the data
    if (parseInt(data[signedPos], 10)) is 1
      #it is negative
      return @_binaryToSignedNumberMSBLSB(data, b, e)
    else
      #it isn't negative
      return @binaryToNumberMSBLSB(data, b, e)


  binaryToSignedNumberLSBMSB: (data, b, e) ->
    signedPos = e
    e-- #decrement e to remove the sign bit from the data
    if (parseInt(data[signedPos], 10)) is 1
      #it is negative
      return @_binaryToSignedNumberLSBMSB(data, b, e)
    else
      #it isn't negative
      return @binaryToNumberLSBMSB(data, b, e)


  #b is MSB   e is LSB    MSB-LSB
  binaryToNumberMSBLSB: (data, b, e) ->
    number = 0
    i = b
    while i <= e
      number <<= 1
      number |= (parseInt(data[i], 10))
      i++
    return number

  #b is MSB   e is LSB    MSB-LSB    b isnt the signed bit!!
  _binaryToSignedNumberMSBLSB: (data, b, e) ->
    number = ~0  #fullfilled number its equal to -1
    i = b
    while i <= e
      number <<= 1
      number |= (parseInt(data[i], 10))
      i++
    return number

  #
  binaryToNumberLSBMSB: (data, b, e) ->
    number = 0
    i = e
    while i >= b
      number <<= 1
      number |= (parseInt(data[i], 10))
      i--
    return number

  _binaryToSignedNumberLSBMSB: (data, b, e) ->
    number = ~0  #fullfilled number its equal to -1
    i = e
    while i >= b
      number <<= 1
      number |= (parseInt(data[i], 10))
      i--
    return number

  numberToBinaryMSBLSB: (number, length) ->
    binary = ''
    i = 0
    while i < length
      binary = (number & 1) + binary
      number >>= 1
      i++
    return binary

  numberToBinaryLSBMSB: (number, length) ->
    binary = ''
    i = 0
    while i < length
      binary = binary + (number & 1)
      number >>= 1
      i++
    return binary

  binaryToBoolean: (data, i) ->
    return (data[i] is '1')

  createParityBit: (stringForParity) ->
    parity = 0
    for bit in stringForParity
      if bit is '1' then parity++
    if parity < 2
      paritybitRef = (parity is 1)
    else
      paritybitRef = ((parity % 2) isnt 0)
    return paritybitRef
	
  hexChecksum: (data) ->
    checksum = 0
    number = @binaryToNumberLSBMSB(data, 0, 31)
    while number > 0
      checksum ^= (number & 0x0F)
      number >>= 4
    return checksum == 0

  # Helper function to reverse a string
  reverse: (s) ->
    if s.length < 2 then s else @reverse(s[1..-1]) + s[0]

  binaryToBitPos: (data, start, end, bitValue=1) ->
    i = Math.log(@binaryToNumberLSBMSB(data, start, end))/Math.log(2)
    # i must be a power of 2
    if i % 1 is 0
      return i + 1
    else
      return 0

  bitPosToBinary: (pos, length, bitValue=1) ->
    if pos < 0 or pos > length
      @numberToBinaryLSBMSB(0, length)
    else if bitValue is 1
      @numberToBinaryLSBMSB(Math.pow(2, pos - 1), length)
    else
      @numberToBinaryLSBMSB(0xF - Math.pow(2, pos - 1), length)

  binaryToOctets: (binary, maxOffset = 0) ->
    s = []
    offset = 0
    while offset < binary.length and (maxOffset is 0 or offset < maxOffset)
      s.push(@binaryToNumber(binary, offset, offset + 7))
      offset+=8
    return s

  generateCrc8Table: (poly = 0) ->
    t = []
    for i in [0..255]
      currentByte = i
      for j in [0..7]
        if (currentByte & 0x80) isnt 0
          currentByte = ((currentByte << 1) ^ poly) % 256
        else
          currentByte = (currentByte << 1) % 256
      t[i] = currentByte
    return t

  crc8: (table, bytes, init = 0, finalXor = 0) ->
    crcValue = init
    for i in [0..bytes.length-1]
      crcValue = table[(crcValue ^ bytes[i]) % 256]
    return crcValue # (crcValue ^ finalXor) % 256
}

module.exports.binaryToNumber = module.exports.binaryToNumberMSBLSB
module.exports.numberToBinary = module.exports.numberToBinaryMSBLSB
module.exports.binaryToSignedNumber = module.exports.binaryToSignedNumberMSBLSB
