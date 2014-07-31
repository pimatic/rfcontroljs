module.exports = {
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
        throw new Error("Data did not match mapping");
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
  binaryToNumber: function(data, b, e) {
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
  binaryToNumberRevert: function(data, b, e) {
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
  binaryToBoolean: function(data, i) {
    return data[i] === '1';
  }
};
