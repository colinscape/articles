fs = require 'fs'

data = []

content = fs.readFileSync './data.json', 'utf8'
module.exports = JSON.parse content
