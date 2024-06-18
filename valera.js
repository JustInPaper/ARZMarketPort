

const http = require('http');
var kamaz = '';
var kamazz = '';


http.createServer((req, res) => {
    var data = 'valera';
    res.writeHead(200).end(data);
    return;
    // res.writeHead(200).end('fail');
}).listen(82, '82.165.57.181');