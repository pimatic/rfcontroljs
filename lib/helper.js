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
    var hadMatch, i, k, len, replace, result, s, search;
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
        for (k = 0, len = mapping.length; k < len; k++) {
          s = mapping[k];
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
    var d, k, len, result;
    result = '';
    for (k = 0, len = data.length; k < len; k++) {
      d = data[k];
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
    var bit, k, len, parity, paritybitRef;
    parity = 0;
    for (k = 0, len = stringForParity.length; k < len; k++) {
      bit = stringForParity[k];
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
  },
  binaryToOctets: function(binary, maxOffset) {
    var offset, s;
    if (maxOffset == null) {
      maxOffset = 0;
    }
    s = [];
    offset = 0;
    while (offset < binary.length && (maxOffset === 0 || offset < maxOffset)) {
      s.push(this.binaryToNumber(binary, offset, offset + 7));
      offset += 8;
    }
    return s;
  },
  generateCrc8Table: function(poly) {
    var currentByte, i, j, k, l, t;
    if (poly == null) {
      poly = 0;
    }
    t = [];
    for (i = k = 0; k <= 255; i = ++k) {
      currentByte = i;
      for (j = l = 0; l <= 7; j = ++l) {
        if ((currentByte & 0x80) !== 0) {
          currentByte = ((currentByte << 1) ^ poly) % 256;
        } else {
          currentByte = (currentByte << 1) % 256;
        }
      }
      t[i] = currentByte;
    }
    return t;
  },
  crc8: function(table, bytes, init, finalXor) {
    var crcValue, i, k, ref;
    if (init == null) {
      init = 0;
    }
    if (finalXor == null) {
      finalXor = 0;
    }
    crcValue = init;
    for (i = k = 0, ref = bytes.length - 1; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
      crcValue = table[(crcValue ^ bytes[i]) % 256];
    }
    return crcValue;
  }
};

module.exports.binaryToNumber = module.exports.binaryToNumberMSBLSB;

module.exports.numberToBinary = module.exports.numberToBinaryMSBLSB;

module.exports.binaryToSignedNumber = module.exports.binaryToSignedNumberMSBLSB;
