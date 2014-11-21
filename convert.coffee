controller = require './index.js'
result = controller.prepareCompressedPulses('942 309 9728 0 0 0 0 0 01011010101010011010101010101001100110011001100112')
console.log result
result2 = controller.fixPulses(result.pulseLengths, result.pulses)
console.log result2