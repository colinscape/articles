#!/usr/bin/env coffee

inputs = process.argv[2...]
count = inputs[0]

timeRequire = (file) ->
  time1 = new Date()
  data = require "./#{count}/#{file}"
  time2 = new Date()
  console.log "Time to read #{data.length} entries from #{file}: #{time2-time1}ms"

timeRequire './rawWrapper'
timeRequire './data.js'
timeRequire './jsonWrapper'
timeRequire './data.coffee'

