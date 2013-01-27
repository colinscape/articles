#!/usr/bin/env coffee

fs = require 'fs'

inputs = process.argv[2...]
count = inputs[0]
args = [1..count].join ','
str = "function f(){}; f(#{args});"
fs.writeFileSync 'test.js', str, 'utf8'
eval str
