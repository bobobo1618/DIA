console = require 'console'

fs = require 'fs'
mime = require 'mime'
uuid = require 'node-uuid'
express = require 'express'
coffee = require 'coffee-script'
riakjs = require 'riak-js'
config = require('./Config').config

app = express.createServer()

db = riakjs.getClient {host:config.riakhost, port:config.riakport.toString()}
console.log db.ping()
dbucket = config.riakbucket

extend = (a1, a2)->
    out = a2
    out[key] = value for key, value of a1
    return out

app.configure ()->
    app.use '/static', express.static __dirname + '/Static'
    app.use express.logger()
    app.use express.bodyParser {uploadDir: './Uploads', keepExtensions: true}
    app.set setting, value for setting, value of config.esettings

app.get '/', (req, res)->
    res.render 'index'

app.get '/add', (req, res)->
    res.render 'add'

app.post '/add', (req, res)->
    filemime = req.files.filedata.type
    filepath = req.files.filedata.path
    filename = req.files.filedata.name

    filemeta = {contentType:filemime, encodeUri:true}
    filemeta = extend filemeta, req.body
    if not req.files.filedata.size
        fs.unlink filepath, (err)->
            if err 
               console.log err
            res.render 'upfailed', { message:'No file sent.'}
        return 1
    if (config.allowedImageTypes.indexOf(filemime) == -1)
        fs.unlink filepath, (err)->
            if err 
               console.log err
            res.render 'upfailed', { message:'Upload failed. Wrong filetype.'}
        return 1
    else
        fs.readFile filepath, 'binary', (err, image)->
            if err
                throw err
                fs.unlink filepath, (err)->
                    if err 
                        res.render 'upfailed', { message:'Something went VERY wrong...'}
                    else
                        res.render 'upfailed', { message:'Something went wrong...'}
            else
                db.save dbucket, filename, image, filemeta, (err, data, meta)->
                    if err
                        console.log err
                        res.render 'upfailed', { message:"Uploading to database didn't work :("}
                    else
                        console.log meta
                        res.render 'added', {message:'Upload complete!'}
                    fs.unlink filepath, (err)->
                        if err 
                            console.log err

app.get '/image/:name', (req, res)->
    db.get dbucket, req.params.name, {encodeUri:true}, (err, data, meta)->
        if not meta.contentType
            console.log meta
            res.render 'noimage', { message:'Image not found :( <br/>Probably the database :/'}
        else
            if err
                console.log err
                res.render 'noimage', { message:'Image not found :('}
            else
                res.writeHead 200, {'Content-Type': meta.contentType}
                res.write data
                res.end()

app.listen config.port, config.host

console.log 'Listening on ' + config.host + ':' + config.port.toString()