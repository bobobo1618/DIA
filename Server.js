(function() {
  var app, coffee, config, console, express, formidable, mime;

  console = require('console');

  mime = require('mime');

  formidable = require('formidable');

  express = require('express');

  coffee = require('coffee-script');

  config = require('./Config').config;

  app = express.createServer();

  app.configure(function() {
    var setting, value, _ref, _results;
    app.use('/static', express.static(__dirname + '/Static'));
    app.use(express.logger());
    app.use(express.bodyParser());
    _ref = config.esettings;
    _results = [];
    for (setting in _ref) {
      value = _ref[setting];
      _results.push(app.set(setting, value));
    }
    return _results;
  });

  app.get('/', function(req, res) {
    return res.render('index', {
      layout: false,
      title: 'Welcome.'
    });
  });

  app.get('/add', function(req, res) {
    return res.render('add', {
      layout: false,
      title: 'New Image'
    });
  });

  app.post('/add', function(req, res) {
    var form;
    form = new formidable.IncomingForm();
    form.on('fileBegin', function(name, file) {
      return console.log('Receiving ' + file.path);
    });
    form.on('progress', function(br, be) {
      return console.log('Progress: ' + br + '/' + be);
    });
    form.on('field', function(f, v) {
      return console.log(f + ':' + v);
    });
    form.on('error', function() {
      return console.log('ERROR');
    });
    form.on('file', function(field, file) {
      return console.log('Got file.');
    });
    form.on('end', function() {
      return res.render('added', {
        layout: false,
        title: 'Upload complete!'
      });
    });
    return form.parse(req);
  });

  app.listen(config.port, config.host);

  console.log('Listening on ' + config.host + ':' + config.port.toString());

}).call(this);
