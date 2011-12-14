options = {
    port: 3001,
    host: '0.0.0.0',
    esettings:{
        views: __dirname + '/Views',
        'view engine': 'jade',
        'case sensitive routes': true
    },
    allowedImageTypes: ['image/jpeg', 'image/gif', 'image/png', 'image/bmp', 'image/svg+xml']
}

module.exports.config = options