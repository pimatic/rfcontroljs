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
  binaryToNumber: function(data, b, e, direction) {
    var i, number;
    if (direction == null) {
      direction = 'MSB-LSB';
    }
    if (direction !== 'MSB-LSB' && direction !== 'LSB-MSB') {
      direction = 'MSB-LSB';
    }
    if (direction === 'MSB-LSB') {
      number = 0;
      i = b;
      while (i <= e) {
        number <<= 1;
        number |= parseInt(data[i], 10);
        i++;
      }
      return number;
    } else {
      number = 0;
      i = e;
      while (i >= b) {
        number <<= 1;
        number |= parseInt(data[i], 10);
        i--;
      }
      return number;
    }
  },
  numberToBinary: function(number, length, direction) {
    var binary, i;
    if (direction == null) {
      direction = 'MSB-LSB';
    }
    if (direction !== 'MSB-LSB' && direction !== 'LSB-MSB') {
      direction = 'MSB-LSB';
    }
    if (direction === 'MSB-LSB') {
      binary = '';
      i = 0;
      while (i < length) {
        binary = (number & 1) + binary;
        number >>= 1;
        i++;
      }
      return binary;
    } else {
      binary = '';
      i = 0;
      while (i < length) {
        binary = binary + (number & 1);
        number >>= 1;
        i++;
      }
      return binary;
    }
  },
  binaryToBoolean: function(data, i) {
    return data[i] === '1';
  }
};
