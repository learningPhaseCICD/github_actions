const http = require('http');
const server = http.createServer((req, res) => {
res.writeHead(200);
res.end('Hello from my CI/CD lab!\n');
});
server.listen(3000);
