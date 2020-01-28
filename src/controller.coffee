helper = require './helper'
protocols = [
  'weather1', 'weather2', 'weather3', 'weather4', 'weather5', 'weather6', 'weather7',
  'weather8', 'weather9', 'weather10', 'weather11', 'weather12', 'weather13', 'weather14',
  'weather15', 'weather16', 'weather17', 'weather18', 'weather19', 'weather20', 'weather21'
  'switch1', 'switch2', 'switch3', 'switch4', 'switch5', 'switch6', 'switch7', 'switch8',
  'switch9', 'switch10', 'switch11', 'switch12', 'switch13', 'switch14', 'switch15', 'switch16',
  'switch17', 'switch18', 'switch19', 'switch20', 'switch21', 'switch22', 'switch23', 'switch24',
  'switch25', 'switch26', 'switch27', 'switch28', 'switch29', 'switch30', 'switch31', 'switch32'
  'switch33'
  'rolling1'
  'dimmer1', 'dimmer2'
  'pir1', 'pir2', 'pir3', 'pir4', 'pir5', 'pir6'
  'contact1', 'contact2', 'contact3', 'contact4'
  'generic', 'generic2'
  'alarm1', 'alarm2', 'alarm3'
  'led1', 'led2', 'led3', 'led4'
  'doorbell1', 'doorbell2', 'doorbell3',
  'awning1', 'awning2'
  'shutter1', 'shutter3', 'shutter4', 'shutter5'
  'rawswitch', 'rawshutter'
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
    return @sortCompressedPulses(pulseLengths, pulses)

  sortCompressedPulses: (pulseLengths, pulses) ->
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
      pulses: protocol.encodeMessage(message)
      pulseLengths: protocol.pulseLengths
    }

  getAllProtocols: ->
    return protocols

  getProtocol: (protocolName) ->
    for p in protocols
      if p.name is protocolName
        return p
    return null
}
