var sys = require('sys');
var static = require('./vendor/node-static/lib/node-static');

//
// Create a node-static server to serve the current directory
//
var file = new(static.Server)('.', { cache: 7200, headers: {'X-Hello':'World!'} });

require('http').createServer(function (req, resp) {
    
    req.body = '';

    req.addListener('data',function(chunk){
      req.body += chunk
    })
    
    req.addListener('end', function () {
        // Remark: here is an example of a simple router with node-static fallback 
        if(req.url == '/'){
          req.url = "index.html";
        }
        file.serve(req, resp, function (err, res) {
            if (err) { // An error as occured
                sys.error("> Error serving " + req.url + " - " + err.message);
                resp.writeHead(err.status, err.headers);
                resp.end();
            } else { // The file was served successfully
                sys.puts("> " + req.url + " - " + res.message);
            }
        });
    });
}).listen(process.ENV.port || 8080);

sys.puts("> asciimo is listening on http://127.0.0.1:8080");
