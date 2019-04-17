rfcontroljs
===========

rfcontroljs is a node.js module written to parse and construct 433mhz On-off keying (OOK)
signals for various devices switches or weather stations. 

It works well together with the [RFControl](https://github.com/pimatic/RFControl) Arduino library
for receiving the signals.

You can find a list of all supported protocols [here](protocols.md).

The Processing Pipeline
-----------------------

### 1. Receiving

The arduino is connected via serial bus to the processing computer (for example a raspberry pi)
and waits for rf signal. 

> Mostly all 433mhzw OOK signals from devices are send multiple times directly in row and have a
> longer footer pulse in between. They differ by the pulse lengths used to encode the data and footer 
> and the pulse count.

[RFControl](https://github.com/pimatic/RFControl) running on the arduino detects the start of a 
signal by its longer footer pulse and verifies it one time by comparing it with the next signal. 
It it unaware of the specific protocol, it just uses the stated fact above. Also we are 
not interested in it if the pulse was a high or low pulse (presence or absence of a carrier wave), 
because the information is decoded in the pulse lengths.

We will call the received sequence of pulse lengths now **timings sequence**. For example a timing
sequence in microseconds could look like this:

```
288  972  292  968  292  972  292  968  292  972  920  344  288  976  920  348  
284  976  288  976  284  976  288  976  288  976  916  348  284  980  916  348  
284  976  920  348  284  976  920  348  284  980  280  980  284  980  916  348  
284  9808
```

You can clearly see the two different pulse lengths (around 304 and 959 microseconds) for the data
encoding and the longer footer pulse (9808 microseconds). 

All observed protocols have less than 8 different pulse length and all pulse length do differ by at 
least a factor of 2. This makes a further compression and simplification possible: We map each 
pulse length to a number from 0 to 7 (a bucket) and calculate for a better accuracy the average of 
all timings mapped to each of the bucket. The result is something like that:

```
buckets: 304, 959, 9808
pulses: 01010101011001100101010101100110011001100101011002
```

To make the representation unique, we choose the buckets in ascending order (respectively we are
sorting it after receiving from the arduino).

We call the sorted buckets **pulse lengths**, the compressed timings **pulse sequence** and the 
length of the pulse sequence (inclusive footer) **pulse count**.

### 2. Protocol Matching

We detect possible protocols by two criteria. The pulse length must match with a small tolerance
and the pulse count must match. 

### 3. Protocol Parsing

If a protocol matches, its `parse` function is called with the pulse sequence. Most protocols are
parsed almost the same way. First the pulse squence must be converted to a binary representation.

In almost all cases there exist a mapping from pulse sequences to a binary `0` and `1`. In this
example the pulse sequence `0110` represents a binary `0` and `0101` maps to a binary `1`:

```CoffeeScript
pulsesToBinaryMapping = {
  '0110': '0' #binary 0
  '0101': '1' #binary 1 
  '02': ''    #footer
}
binary = helper.map(pulses, pulsesToBinaryMapping)
```

The binary reprsentation now looks like this:

```
110011000010
```

As last step the protocol dependent information must be extracted from the binary representation:

```CoffeeScript
result = {
  houseCode: helper.binaryToNumber(binary, 0, 5)
  unitCode: helper.binaryToNumber(binary, 6, 10)
  state: helper.binaryToBoolean(binary, 12)
}
```


Details
--------

RFControl is more sensitive than needed for most protocols. 
So we get sometimes, depending of the accuracy of the sender/remote, different bucket counts. 

This is by design, to catch up further protocols that maybe need a higher sensitivity. The specific
protocol has not to deal with this issue, because `rfcontroljs` auto merges similar buckets before
calling the `decodePulses` function of each protocol.

The algorithm is the following:

  1. Record the (maybe to many) buckets and compressed pulses with [RFControl](https://github.com/pimatic/RFControl) (arduino / c++)
  2. Sort the buckets in `rfcontroljs` [`prepareCompressedPulses`](https://github.com/pimatic/rfcontroljs/blob/f39db799ae1fc86cda74c33a01c27da40eb3c9e8/src/controller.coffee#L68)
  3. Try to find a matching protocol in rfcontroljs [`decodePulses`](https://github.com/pimatic/rfcontroljs/blob/f39db799ae1fc86cda74c33a01c27da40eb3c9e8/src/controller.coffee#L118)
  4. If we have more than 3 buckets and two of the buckets are similar (`b1*2 < b2`) we merge them to just one bucket by averaging and adapting the pulses in  rfcontroljs [`fixPulses`](https://github.com/pimatic/rfcontroljs/blob/f39db799ae1fc86cda74c33a01c27da40eb3c9e8/src/controller.coffee#L89)
  5. Go to step 3

Adding a new Protocol
--------------------

## Preparation

1. Fork the rfcontroljs repository and clone your fork into a local directory.
2. run `npm install` inside the cloned directory, so that all dependencies get installed.
3. We are using [gulp](http://gulpjs.com/) for automating tests and automatic coffee-script compilation. So best to install it global: `npm install --global gulp`
4. You should be able to run the tests with `gulp test`.
5. Running just `gulp` let it compile all files and whats for changes. So always keep in running while editing coffee-files.

## Protocol development

1. Create a new protocol file (like the other) in `src/protocols`.
2. Add its name in the `src/controller.coffee` file to [the protocol list](https://github.com/pimatic/rfcontroljs/blob/master/src/controller.coffee#L2).
3. Add a test case to the `#decodePulses()` test case list in `test/lib-controller.coffee` with the data from the arduino ([like this one](https://github.com/pimatic/rfcontroljs/blob/master/test/lib-controller.coffee#L65-L74)). For the `pulseLengths`: strip the zero's at the end and sort them in ascending order, also adapt the `pulse` to the changed sorting. [1]
4. Adapt the protocol file, so that the test get passed.

[1] You can also use this script to convert the output to a valid test input:

```coffee
controller = require './index.js'
result = controller.prepareCompressedPulses('255 2904 1388 771 11346 0 0 0 0100020002020000020002020000020002000202000200020002000200000202000200020000020002000200020002020002000002000200000002000200020002020002000200020034')
console.log result
result2 = controller.fixPulses(result.pulseLengths, result.pulses)
console.log result2
```
sample output:

```
coffee convert.coffee 
{ pulseLengths: [ 255, 771, 1388, 2904, 11346 ],
  pulses: '0300020002020000020002020000020002000202000200020002000200000202000200020000020002000200020002020002000002000200000002000200020002020002000200020014' }
{ pulseLengths: [ 255, 1079, 2904, 11346 ],
  pulses: '0200010001010000010001010000010001000101000100010001000100000101000100010000010001000100010001010001000001000100000001000100010001010001000100010013' }
```
The second line should be used for protocol developing.
