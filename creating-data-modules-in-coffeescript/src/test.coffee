#!/usr/bin/env coffee

inputs = process.argv[2...]
count = inputs[0]

timeRequire = (file) ->
  time1 = new Date()
  data = require "./#{count}/#{file}"
  time2 = new Date()
  console.log "Time to read #{data.length} entries from #{file}: #{time2-time1}ms"

timeRequire './jsonWrapper'
timeRequire './rawWrapper'
timeRequire './data-json.js'
timeRequire './data-json.coffee'
timeRequire './data-min.js'
timeRequire './data.js'
timeRequire './data-min.coffee'
timeRequire './data.coffee'
