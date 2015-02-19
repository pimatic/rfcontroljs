helper = require './helper'
protocols = [
  'weather1', 'weather2', 'weather3', 'weather4', 'weather5', 'weather6', 'weather7'
  'switch1', 'switch2', 'switch3', 'switch4', 'switch5', 'switch6', 'switch7', 'switch8', 'switch9'
  'switch10', 'switch11'
  'rolling1'
  'dimmer1',
  'pir1', 'pir2',
  'contact1', 'contact2',
  'generic'
]
# load protocol files:
protocols = protocols.map( (p) => require("./protocols/#{p}")(helper) )

doesProtocolMatch = (pulseLengths, pulses, protocol) ->
  if protocol.pulseCounts?
    unless pulses.length in protocol.pulseCounts then return false
  else
    unless pulses.length is protocol.pulseCount then return false

  unless pulseLengths.length is protocol.pulseLengths.length then return false
  i = 0
  while i < pulseLengths.length
    maxDelta = pulseLengths[i]*0.4
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

  fixPulses: (pulseLengths, pulses) ->
    # if we have less then 3 different pulseLenght there is nothing to fix
    if pulseLengths.length <= 3 then return null
    # consider timing as the same if they differ less then ain a factor of 2
    i = 1
    while i < pulseLengths.length
      if pulseLengths[i-1] * 2 < pulseLengths[i]
        i++
        continue
      # merge pulseLengths[i-1] and pulseLengths[i]
      newPulseLength = Math.floor((pulseLengths[i-1] + pulseLengths[i]) / 2)
      # replace the old two pulse length with the new one
      newPulseLengths = pulseLengths.slice()
      newPulseLengths.splice(i-1, 2, newPulseLength)
      break
    # nothing to do...
    if i is pulseLengths.length
      return null
    # adapt pulses
    newPulses = pulses
    while i < pulseLengths.length
      newPulses = newPulses.replace(new RegExp("#{i}", 'g'), "#{i-1}")
      i++
    return {
      pulseLengths: newPulseLengths
      pulses: newPulses
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
            if err instanceof helper.ParsingError
              console.log "Warning trying to parse message with protocol #{p.name}: #{err.message}"
              console.log "#{err.stack.split("\n")[2]}"
            else
              throw err
    # try to fix pulses
    fixed = @fixPulses(pulseLengths, pulses)
    unless fixed?
      # no fixes, then just return the results
      return results
    # We have fixes so try again with the fixed pulse lengths...
    return results.concat(@decodePulses(fixed.pulseLengths, fixed.pulses))

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
