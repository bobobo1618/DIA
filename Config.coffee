options = {
    port: 3001,
    host: '0.0.0.0',
    riakhost: '192.168.1.159',
    riakport: 30126,
    riakbucket: 'images',
    esettings:{
        views: __dirname + '/Views',
        'view engine': 'jade',
        'case sensitive routes': true
        'view options': {layout:false}
    },
    allowedImageTypes: ['image/jpeg', 'image/gif', 'image/png', 'image/bmp', 'image/svg+xml']
}

module.exports.config = options