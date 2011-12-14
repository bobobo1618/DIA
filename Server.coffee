console = require 'console'

fs = require 'fs'
mime = require 'mime'
express = require 'express'
coffee = require 'coffee-script'
config = require('./Config').config

app = express.createServer()

app.configure(()->
    app.use '/static', express.static __dirname + '/Static'
    app.use express.logger()
    app.use express.bodyParser {uploadDir: './Uploads', keepExtensions: true}
    app.set setting, value for setting, value of config.esettings
)

app.get('/', (req, res)->
    res.render 'index', {layout: false, title: 'Welcome.'}
)

app.get('/add', (req, res)->
    res.render 'add', {layout: false, title: 'New Image'}
)

app.post('/add', (req, res)->
    filemime = req.files.filedata.type
    if config.allowedImageTypes.indexOf(filemime) == -1
        fs.unlink req.files.filedata.path, (err)->
            if err 
                throw err
            res.render 'added', {layout: false, title: 'Wrong filetype.', message:'Upload failed. Wrong filetype.'}
    else
        res.render 'added', {layout: false, title: 'Upload complete.', message:'Upload complete!'}
)

app.listen config.port, config.host

console.log 'Listening on ' + config.host + ':' + config.port.toString()