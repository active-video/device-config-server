const restafary = require('restafary');
const http = require('http');
const express = require('express');
const path = require('path');
const colors = require('cli-color');

const app = express();
const server = http.createServer(app);

const port = 8299;
const ip = '0.0.0.0';
const service = 'http://' + ip + ':' + port + '/device';

app.use(restafary({
    prefix: '/device',
    root: path.resolve(__dirname, 'devices')
}));

app.use(express.static(__dirname));

// Info about what we are doing
console.log('=== \nStarting Device API on http://%s:%d\n===', ip, port);
console.log('Sample Request: \n\tCreate Device:\n\t\t%s, \n\tDelete Device:\n\t\t%s, \n\tGet Device:\n\t\t%s',
    colors.yellow('curl --request PUT ' + service + '/some-device-id-here --data \'{"deviceType": "moto", "deviceCookie": "5678"}\''),
    colors.red('curl --request DELETE ' + service + '/some-device-id-here'),
    colors.green('curl --request GET ' + service + '/some-device-id-here')
);


// Start it up
server.listen(port, ip);