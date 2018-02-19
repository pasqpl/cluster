var http = require('http');
var os = require('os');

var msg = 'Hello World! ' + os.hostname();

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);
  response.end(msg);
};

var www = http.createServer(handleRequest);
www.listen(8080);
