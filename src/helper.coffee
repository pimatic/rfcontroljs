class ParsingError extends Error
  constructor: (@message,@cause)->
    Error.captureStackTrace(this, ParsingError)

module.exports = {
  ParsingError: ParsingError
  map: (data, mapping) ->
    i = 0
    result = ''
    while i < data.length
      hadMatch = false
      # try each mapping rool
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
    return result

  mapByArray: (data, mapping) ->
    result = ''
    for d in data
      result += mapping[parseInt(d, 10)]
    return result

  binaryToNumber: (data, b, e, direction = 'MSB-LSB') ->
    if direction != 'MSB-LSB' and direction != 'LSB-MSB' then direction = 'MSB-LSB'
    if direction is 'MSB-LSB'
      return @_binaryToNumberMSBLSB(data, b, e)
    else
      return @_binaryToNumberLSBMSB(data, b, e)

  #converts the binary data to a singed number. if the position of the signed bit isnt set, it used the MSB
  binaryToNumberSigned: (data, b, e, direction = 'MSB-LSB', signedPos = null) ->
    if direction != 'MSB-LSB' and direction != 'LSB-MSB' then direction = 'MSB-LSB'
    if direction is 'MSB-LSB'
      unless signedPos? #it is possible, that the signedbit is seperate from the data
        signedPos = b
        b++ #increment b to remove the signedbit from the data
      if (parseInt(data[signedPos], 10)) is 1
        #it is negativ
        return @_binaryToNumberMSBLSBsigned(data, b, e)
      else
        #it isnt negativ
        return @_binaryToNumberMSBLSB(data, b, e)
    else
      unless signedPos?
        signedPos = e
        e-- #decrement e to remove the signedbit from the data
      if (parseInt(data[signedPos], 10)) is 1
        #it is negativ
        return @_binaryToNumberLSBMSBsigned(data, b, e)
      else
        #it isnt negativ
        return @_binaryToNumberLSBMSB(data, b, e)

   #b is MSB   e is LSB    MSB-LSB
  _binaryToNumberMSBLSB: (data, b, e) ->
    number = 0
    i = b
    while i <= e
      number <<= 1
      number |= (parseInt(data[i], 10))
      i++
    return number

   #b is MSB   e is LSB    MSB-LSB    b isnt the signed bit!!
  _binaryToNumberMSBLSBsigned: (data, b, e) ->
    number = ~0  #fullfilled number its equal to -1
    i = b
    while i <= e
      number <<= 1
      number |= (parseInt(data[i], 10))   # "|=" or     "&=" and
      i++
    return number

  #
  _binaryToNumberLSBMSB: (data, b, e) ->
    number = 0
    i = e
    while i >= b
      number <<= 1
      number |= (parseInt(data[i], 10))
      i--
    return number

  _binaryToNumberLSBMSBsigned: (data, b, e) ->
    number = ~0  #fullfilled number its equal to -1
    i = e
    while i >= b
      number <<= 1
      number |= (parseInt(data[i], 10))
      i--
    return number

  numberToBinary: (number, length, direction = 'MSB-LSB') ->
    if direction != 'MSB-LSB' and direction != 'LSB-MSB' then direction = 'MSB-LSB'
    if direction is 'MSB-LSB'
      binary = ''
      i = 0
      while i < length
        binary = (number & 1) + binary
        number >>= 1
        i++
      return binary
    else
      binary = ''
      i = 0
      while i < length
        binary = binary + (number & 1)
        number >>= 1
        i++
      return binary

  binaryToBoolean: (data, i) ->
    return (data[i] is '1')
}