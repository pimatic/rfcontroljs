var doesProtocolMatch, helper, protocols, sortIndices,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

helper = require('./helper');

protocols = ['weather1', 'weather2', 'weather3', 'weather4', 'weather5', 'weather6', 'weather7', 'weather8', 'weather9', 'weather10', 'weather11', 'weather12', 'weather13', 'weather14', 'weather15', 'weather16', 'weather17', 'weather18', 'weather19', 'switch1', 'switch2', 'switch3', 'switch4', 'switch5', 'switch6', 'switch7', 'switch8', 'switch9', 'switch10', 'switch11', 'switch12', 'switch13', 'switch14', 'switch15', 'switch16', 'switch17', 'switch18', 'switch19', 'switch20', 'switch21', 'switch22', 'switch23', 'switch24', 'switch25', 'switch26', 'switch27', 'switch28', 'switch29', 'switch30', 'rolling1', 'dimmer1', 'dimmer2', 'pir1', 'pir2', 'pir3', 'pir4', 'pir5', 'pir6', 'contact1', 'contact2', 'contact3', 'contact4', 'generic', 'generic2', 'alarm1', 'alarm2', 'led1', 'led2', 'led3', 'led4', 'doorbell1', 'doorbell2', 'doorbell3', 'awning1', 'awning2', 'shutter1', 'shutter3', 'shutter4', 'shutter5', 'rawswitch', 'rawshutter'];

protocols = protocols.map((function(_this) {
  return function(p) {
    return require("./protocols/" + p)(helper);
  };
})(this));

doesProtocolMatch = function(pulseLengths, pulses, protocol) {
  var i, maxDelta, ref;
  if (protocol.pulseCounts != null) {
    if (ref = pulses.length, indexOf.call(protocol.pulseCounts, ref) < 0) {
      return false;
    }
  } else {
    if (pulses.length !== protocol.pulseCount) {
      return false;
    }
  }
  if (pulseLengths.length !== protocol.pulseLengths.length) {
    return false;
  }
  i = 0;
  while (i < pulseLengths.length) {
    maxDelta = pulseLengths[i] * 0.4;
    if (Math.abs(pulseLengths[i] - protocol.pulseLengths[i]) > maxDelta) {
      return false;
    }
    i++;
  }
  return true;
};

sortIndices = function(array) {
  var e, i, indices, j, k, len, len1, m, tuple, tuples;
  tuples = new Array(array.length);
  for (i = k = 0, len = array.length; k < len; i = ++k) {
    e = array[i];
    tuples[i] = [e, i];
  }
  tuples.sort(function(left, right) {
    if (left[0] < right[0]) {
      return -1;
    } else {
      return 1;
    }
  });
  indices = new Array(array.length);
  for (j = m = 0, len1 = tuples.length; m < len1; j = ++m) {
    tuple = tuples[j];
    indices[tuple[1]] = j;
  }
  return indices;
};

module.exports = {
  debug: false,
  compressTimings: function(timings) {
    var bucket, buckets, counts, hasMatch, i, j, k, len, len1, len2, m, n, pulses, sums, timing;
    pulses = '';
    buckets = [];
    sums = [];
    counts = [];
    for (i = k = 0, len = timings.length; k < len; i = ++k) {
      timing = timings[i];
      hasMatch = false;
      for (j = m = 0, len1 = buckets.length; m < len1; j = ++m) {
        bucket = buckets[j];
        if (Math.abs(bucket - timing) < bucket * 0.5) {
          pulses += j;
          sums[j] += timing;
          counts[j]++;
          hasMatch = true;
        }
      }
      if (!hasMatch) {
        pulses += buckets.length;
        buckets.push(timing);
        sums.push(timing);
        counts.push(1);
      }
    }
    for (j = n = 0, len2 = buckets.length; n < len2; j = ++n) {
      bucket = buckets[j];
      buckets[j] = Math.round(sums[j] / counts[j]);
    }
    return {
      buckets: buckets,
      pulses: pulses
    };
  },
  prepareCompressedPulses: function(input) {
    var parts, pulseLengths, pulses;
    parts = input.split(' ');
    pulseLengths = parts.slice(0, 8);
    pulses = parts[8];
    pulseLengths = pulseLengths.filter(function(puls) {
      return puls !== '0';
    }).map(function(puls) {
      return parseInt(puls, 10);
    });
    return this.sortCompressedPulses(pulseLengths, pulses);
  },
  sortCompressedPulses: function(pulseLengths, pulses) {
    var sortedIndices;
    sortedIndices = sortIndices(pulseLengths);
    pulseLengths.sort(function(l, r) {
      return l - r;
    });
    pulses = helper.mapByArray(pulses, sortedIndices);
    return {
      pulseLengths: pulseLengths,
      pulses: pulses
    };
  },
  fixPulses: function(pulseLengths, pulses) {
    var i, newPulseLength, newPulseLengths, newPulses;
    if (pulseLengths.length <= 3) {
      return null;
    }
    i = 1;
    while (i < pulseLengths.length) {
      if (pulseLengths[i - 1] * 2 < pulseLengths[i]) {
        i++;
        continue;
      }
      newPulseLength = Math.floor((pulseLengths[i - 1] + pulseLengths[i]) / 2);
      newPulseLengths = pulseLengths.slice();
      newPulseLengths.splice(i - 1, 2, newPulseLength);
      break;
    }
    if (i === pulseLengths.length) {
      return null;
    }
    newPulses = pulses;
    while (i < pulseLengths.length) {
      newPulses = newPulses.replace(new RegExp("" + i, 'g'), "" + (i - 1));
      i++;
    }
    return {
      pulseLengths: newPulseLengths,
      pulses: newPulses
    };
  },
  decodePulses: function(pulseLengths, pulses) {
    var err, fixed, k, len, p, results, values;
    results = [];
    for (k = 0, len = protocols.length; k < len; k++) {
      p = protocols[k];
      if (doesProtocolMatch(pulseLengths, pulses, p)) {
        try {
          values = p.decodePulses(pulses);
          results.push({
            protocol: p.name,
            values: values
          });
        } catch (error) {
          err = error;
          if (this.debug) {
            if (err instanceof helper.ParsingError) {
              console.log("Warning trying to parse message with protocol " + p.name + ": " + err.message);
              console.log("" + (err.stack.split("\n")[2]));
            } else {
              throw err;
            }
          }
        }
      }
    }
    fixed = this.fixPulses(pulseLengths, pulses);
    if (fixed == null) {
      return results;
    }
    return results.concat(this.decodePulses(fixed.pulseLengths, fixed.pulses));
  },
  encodeMessage: function(protocolName, message) {
    var k, len, p, protocol;
    protocol = null;
    for (k = 0, len = protocols.length; k < len; k++) {
      p = protocols[k];
      if (p.name === protocolName) {
        protocol = p;
        break;
      }
    }
    if (protocol == null) {
      throw new Error("Could not find a protocol named " + protocolName);
    }
    if (protocol.encodeMessage == null) {
      throw new Error("The protocol has no send report.");
    }
    return {
      pulses: protocol.encodeMessage(message),
      pulseLengths: protocol.pulseLengths
    };
  },
  getAllProtocols: function() {
    return protocols;
  },
  getProtocol: function(protocolName) {
    var k, len, p;
    for (k = 0, len = protocols.length; k < len; k++) {
      p = protocols[k];
      if (p.name === protocolName) {
        return p;
      }
    }
    return null;
  }
};
