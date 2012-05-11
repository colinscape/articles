fs = require 'fs'

data = []

content = fs.readFileSync './data.txt', 'utf8'
lines = content.split '\n'
for line in lines
  if line.length > 1
    parts = line.split '\t'
    data.push {name: parts[0], cf: parts[1]}


module.exports = data
