helper = require './helper'
protocols = [
  'weather1', 'weather2', 'weather3',
  'switch1', 'switch2', 'switch3', 'switch4',
  'pir1', 'generic'
]
# load protocol files:
protocols = protocols.map( (p) => require("./protocols/#{p}")(helper) )

doesProtocolMatch = (pulseLengths, pulses, protocol) ->
  unless pulses.length is protocol.pulseCount then return false
  unless pulseLengths.length is protocol.pulseLengths.length then return false
  i = 0
  while i < pulseLengths.length
    maxDelta = pulseLengths[i]*0.25
    if Math.abs(pulseLengths[i] - protocol.pulseLengths[i]) > maxDelta
      return false
    i++
  return true

sortIndices = (array) ->
  tuples = new Array(array.length)
  for e, i in array
    tuples[i] = [e, i]
  tuples.sort( (left, right) -> (if left[0] < right[0] then -1 else 1) )
  indices = new Array(array.length)
  for tuple, j in tuples
    indices[tuple[1]] = j
  return indices
  

module.exports = {
  debug: false
  compressTimings: (timings) ->
    pulses = ''
    buckets = []
    sums = []
    counts = []
    for timing, i in timings
      #search for a bucket
      hasMatch = no
      for bucket, j in buckets
        if Math.abs(bucket - timing) < bucket*0.5
          pulses += j
          sums[j] += timing
          counts[j]++
          hasMatch = yes
      unless hasMatch
        # create new bucket
        pulses += buckets.length
        buckets.push timing
        sums.push timing
        counts.push 1

    for bucket, j in buckets
      buckets[j] = Math.round(sums[j] / counts[j])
    return {
      buckets
      pulses
    }

  prepareCompressedPulses: (input) ->
    # input is something like:
    # "268 2632 1282 10168 0 0 0 0 010002000202000002000200020200020002..."
    # The first 8 numbers are the pulse length
    # and the last string is the pulse sequence
    parts = input.split(' ')
    pulseLengths = parts[0..7]
    pulses = parts[8]
    # Now lets filter out 0 puses
    pulseLengths = pulseLengths
      .filter( (puls) -> puls isnt '0' )
      .map( (puls) -> parseInt(puls, 10) )
    # next sort the pulses from short to long and update indces in pulse
    sortedIndices = sortIndices(pulseLengths)
    pulseLengths.sort( (l,r) -> l-r )
    pulses = helper.mapByArray(pulses, sortedIndices)
    return {
      pulseLengths
      pulses
    }

  decodePulses: (pulseLengths, pulses) ->
    results = []
    # test for each protocol
    for p in protocols
      # First test if pulse count and pulse lengths match
      if doesProtocolMatch(pulseLengths, pulses, p)
        # Then try to parse
        try
          values = p.decodePulses(pulses)
          results.push {
            protocol: p.name
            values: values
          }
        catch err
          if @debug
            console.log "Error trying to parse message with protocol #{p.name}: #{err.stack}"
          unless err instanceof helper.ParsingError
            throw err
    return results

  encodeMessage: (protocolName, message) ->
    protocol = null
    for p in protocols
      if p.name is protocolName
        protocol = p
        break
    unless protocol? then throw new Error("Could not find a protocol named #{protocolName}")
    unless protocol.encodeMessage? then throw new Error("The protocol has no send report.")
    return {
      pulseLengths: protocol.pulseLengths
      pulses: protocol.encodeMessage(message)
    }

  getAllProtocols: ->
    return protocols

  getProtocol: (protocolName) ->
    for p in protocols
      if p.name is protocolName
        return p
    return null
}
