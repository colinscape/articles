fs = require 'fs'

data = []

content = fs.readFileSync "#{__dirname}/data.json", 'utf8'
module.exports = JSON.parse content
