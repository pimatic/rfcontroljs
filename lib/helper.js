var ParsingError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ParsingError = (function(superClass) {
  extend(ParsingError, superClass);

  function ParsingError(message, cause) {
    this.message = message;
    this.cause = cause;
    Error.captureStackTrace(this, ParsingError);
  }

  return ParsingError;

})(Error);

module.exports = {
  ParsingError: ParsingError,
  map: function(data, mapping) {
    var hadMatch, i, j, len, replace, result, s, search;
    i = 0;
    result = '';
    if (!Array.isArray(mapping)) {
      while (i < data.length) {
        hadMatch = false;
        for (search in mapping) {
          replace = mapping[search];
          if (data.length - i >= search.length) {
            if (data.substr(i, search.length) === search) {
              result += replace;
              i += search.length;
              hadMatch = true;
              break;
            }
          }
        }
        if (!hadMatch) {
          throw new ParsingError("Data did not match mapping");
        }
      }
    } else {
      while (i < data.length) {
        hadMatch = false;
        for (j = 0, len = mapping.length; j < len; j++) {
          s = mapping[j];
          search = Object.keys(s)[0];
          replace = s[search];
          if (data.length - i >= search.length) {
            if (data.substr(i, search.length) === search) {
              result += replace;
              i += search.length;
              hadMatch = true;
              break;
            }
          }
        }
        if (!hadMatch) {
          throw new ParsingError("Data did not match mapping");
        }
      }
    }
    return result;
  },
  mapByArray: function(data, mapping) {
    var d, j, len, result;
    result = '';
    for (j = 0, len = data.length; j < len; j++) {
      d = data[j];
      result += mapping[parseInt(d, 10)];
    }
    return result;
  },
  binaryToSignedNumberMSBLSB: function(data, b, e) {
    var signedPos;
    signedPos = b;
    b++;
    if ((parseInt(data[signedPos], 10)) === 1) {
      return this._binaryToSignedNumberMSBLSB(data, b, e);
    } else {
      return this.binaryToNumberMSBLSB(data, b, e);
    }
  },
  binaryToSignedNumberLSBMSB: function(data, b, e) {
    var signedPos;
    signedPos = e;
    e--;
    if ((parseInt(data[signedPos], 10)) === 1) {
      return this._binaryToSignedNumberLSBMSB(data, b, e);
    } else {
      return this.binaryToNumberLSBMSB(data, b, e);
    }
  },
  binaryToNumberMSBLSB: function(data, b, e) {
    var i, number;
    number = 0;
    i = b;
    while (i <= e) {
      number <<= 1;
      number |= parseInt(data[i], 10);
      i++;
    }
    return number;
  },
  _binaryToSignedNumberMSBLSB: function(data, b, e) {
    var i, number;
    number = ~0;
    i = b;
    while (i <= e) {
      number <<= 1;
      number |= parseInt(data[i], 10);
      i++;
    }
    return number;
  },
  binaryToNumberLSBMSB: function(data, b, e) {
    var i, number;
    number = 0;
    i = e;
    while (i >= b) {
      number <<= 1;
      number |= parseInt(data[i], 10);
      i--;
    }
    return number;
  },
  _binaryToSignedNumberLSBMSB: function(data, b, e) {
    var i, number;
    number = ~0;
    i = e;
    while (i >= b) {
      number <<= 1;
      number |= parseInt(data[i], 10);
      i--;
    }
    return number;
  },
  numberToBinaryMSBLSB: function(number, length) {
    var binary, i;
    binary = '';
    i = 0;
    while (i < length) {
      binary = (number & 1) + binary;
      number >>= 1;
      i++;
    }
    return binary;
  },
  numberToBinaryLSBMSB: function(number, length) {
    var binary, i;
    binary = '';
    i = 0;
    while (i < length) {
      binary = binary + (number & 1);
      number >>= 1;
      i++;
    }
    return binary;
  },
  binaryToBoolean: function(data, i) {
    return data[i] === '1';
  },
  createParityBit: function(stringForParity) {
    var bit, j, len, parity, paritybitRef;
    parity = 0;
    for (j = 0, len = stringForParity.length; j < len; j++) {
      bit = stringForParity[j];
      if (bit === '1') {
        parity++;
      }
    }
    if (parity < 2) {
      paritybitRef = parity === 1;
    } else {
      paritybitRef = (parity % 2) !== 0;
    }
    return paritybitRef;
  },
  hexChecksum: function(data) {
    var checksum, number;
    checksum = 0;
    number = this.binaryToNumberLSBMSB(data, 0, 31);
    while (number > 0) {
      checksum ^= number & 0x0F;
      number >>= 4;
    }
    return checksum === 0;
  },
  reverse: function(s) {
    if (s.length < 2) {
      return s;
    } else {
      return this.reverse(s.slice(1)) + s[0];
    }
  },
  binaryToBitPos: function(data, start, end, bitValue) {
    var i;
    if (bitValue == null) {
      bitValue = 1;
    }
    i = Math.log(this.binaryToNumberLSBMSB(data, start, end)) / Math.log(2);
    if (i % 1 === 0) {
      return i + 1;
    } else {
      return 0;
    }
  },
  bitPosToBinary: function(pos, length, bitValue) {
    if (bitValue == null) {
      bitValue = 1;
    }
    if (pos < 0 || pos > length) {
      return this.numberToBinaryLSBMSB(0, length);
    } else if (bitValue === 1) {
      return this.numberToBinaryLSBMSB(Math.pow(2, pos - 1), length);
    } else {
      return this.numberToBinaryLSBMSB(0xF - Math.pow(2, pos - 1), length);
    }
  }
};

module.exports.binaryToNumber = module.exports.binaryToNumberMSBLSB;

module.exports.numberToBinary = module.exports.numberToBinaryMSBLSB;

module.exports.binaryToSignedNumber = module.exports.binaryToSignedNumberMSBLSB;
