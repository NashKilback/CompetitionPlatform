const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 3015;

const server = http.createServer((req, res) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  let filePath;
  
  // Route handling
  if (req.url === '/test' || req.url === '/test.html') {
    filePath = path.join(__dirname, 'test.html');
  } else {
    // Default to main app
    filePath = path.join(__dirname, 'frontend', 'index.html');
  }
  
  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(404);
      res.end(`
        <html><body style="font-family: Arial; background: #0f172a; color: white; text-align: center; padding: 50px;">
          <h1>🚫 File Not Found</h1>
          <p>Error: ${err.message}</p>
          <p><a href="/" style="color: #3b82f6;">返回首页 / Go Home</a></p>
          <p><a href="/test" style="color: #3b82f6;">测试页面 / Test Page</a></p>
        </body></html>
      `);
      return;
    }

    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(content);
  });
});

server.listen(port, () => {
  console.log('🏆 Competition Scoring Platform');
  console.log('='.repeat(50));
  console.log(`🌐 Server running at: http://localhost:${port}`);
  console.log(`🧪 Test page at: http://localhost:${port}/test`);
  console.log('🔐 Privacy-preserving judge scoring');
  console.log('⚡ Powered by FHE technology');
  console.log('='.repeat(50));
  console.log('✨ Platform is ready! Open the URL above in your browser.');
});