options = {
    port: 3001,
    host: '0.0.0.0',
    esettings:{
        views: __dirname + '/Views',
        'view engine': 'jade',
        'case sensitive routes': true
    }
}

module.exports.config = options