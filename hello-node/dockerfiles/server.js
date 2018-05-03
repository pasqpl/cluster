var http = require('http');
var os = require('os');



var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  var msg = 'Hello World! ' + os.hostname() + ' process uptime: ' + process.uptime() + ' os uptime: ' + require('os').uptime(); 
  response.writeHead(200);
  response.end(msg);
};

var www = http.createServer(handleRequest);
www.listen(8080);
