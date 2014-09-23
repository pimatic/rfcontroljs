rfcontroljs
===========

rfcontroljs is a node.js module written to parse and construct 433mhz On-off keying (OOK)
signals for various devices switches or weather stations. 

It works well together with the [RFControl](https://github.com/pimatic/RFControl) Arduino library
for receving the signals.

You can find a list of all supported protocols [here](protocols.md)

The Processing Pipeline
-----------------------

### 1. Receiving

The arduino is connecte via serial bus to the processing computer (for example a raspberry pi)
and waits for rf signal. 

> Mostly all 433mhzw OOK signals from devices are send multiple times directly in row and have a
> longer footer pulse in between. They differ by the pulse lengths used to encode the data and footer 
> and the pulse count.

[RFControl](https://github.com/pimatic/RFControl) running on the arduino detects the start of a 
signal by its longer footer pulse and verifies it one time by comparing it with the next signal. 
It does nothing know about the specific protocol, it just uses the stated fact above. Also we aren't
interested in if the pulse was a high or low pulse (presence or absence of a carrier wave), 
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

As last step the protocol dependend information must be extracted from the binary representation:

```CoffeeScript
result = {
  houseCode: helper.binaryToNumber(binary, 0, 5)
  unitCode: helper.binaryToNumber(binary, 6, 10)
  state: helper.binaryToBoolean(binary, 12)
}
```