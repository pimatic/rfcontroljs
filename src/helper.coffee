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

  # converts the binary data to a singed number. 
  binaryToSignedNumberMSBLSB: (data, b, e) ->
    signedPos = b
    b++ #increment b to remove the signedbit from the data
    if (parseInt(data[signedPos], 10)) is 1
      #it is negativ
      return @_binaryToSignedNumberMSBLSB(data, b, e)
    else
      #it isnt negativ
      return @binaryToNumberMSBLSB(data, b, e)


  binaryToSignedNumberLSBMSB: (data, b, e) ->
    signedPos = e
    e-- #decrement e to remove the signedbit from the data
    if (parseInt(data[signedPos], 10)) is 1
      #it is negativ
      return @_binaryToSignedNumberLSBMSB(data, b, e)
    else
      #it isnt negativ
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
}

module.exports.binaryToNumber = module.exports.binaryToNumberMSBLSB
module.exports.numberToBinary = module.exports.numberToBinaryMSBLSB
module.exports.binaryToSignedNumber = module.exports.binaryToSignedNumberMSBLSB