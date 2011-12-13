console = require 'console'

console.log 'Starting!'
console.log 'Requiring...'

mime = require 'mime'
express = require 'express'
coffee = require 'coffee-script'
config = require('./Config').config

console.log 'Creating Express server...'

app = express.createServer()

console.log 'Configuring Express server...'

app.configure(()->
    app.use '/static', express.static __dirname + '/Static'
    app.set setting, value for setting, value of config.esettings
)

console.log 'Registering handlers...'

app.get('/', (req, res)->
    console.log 'Serving a request for ' + req.url
    res.render 'index', {layout: 'default', title: 'Welcome.'}
)

console.log 'Starting to listen...'

app.listen config.port, config.host

console.log 'Listening on ' + config.host + ':' + config.port.toString()