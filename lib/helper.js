var ParsingError,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ParsingError = (function(_super) {
  __extends(ParsingError, _super);

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
    var hadMatch, i, replace, result, search;
    i = 0;
    result = '';
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
    return result;
  },
  mapByArray: function(data, mapping) {
    var d, result, _i, _len;
    result = '';
    for (_i = 0, _len = data.length; _i < _len; _i++) {
      d = data[_i];
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
    var bit, parity, paritybitRef, _i, _len;
    parity = 0;
    for (_i = 0, _len = stringForParity.length; _i < _len; _i++) {
      bit = stringForParity[_i];
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
    number = binaryToNumberLSBMSB(data, 0, 31);
    while (data > 0) {
      checksum ^= data & 0x0F;
      data >>= 4;
    }
    return checksum === 0;
  }
};

module.exports.binaryToNumber = module.exports.binaryToNumberMSBLSB;

module.exports.numberToBinary = module.exports.numberToBinaryMSBLSB;

module.exports.binaryToSignedNumber = module.exports.binaryToSignedNumberMSBLSB;
