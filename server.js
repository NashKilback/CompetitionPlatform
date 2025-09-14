const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3015;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('frontend'));

// Serve the main application
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'frontend', 'index.html'));
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Competition Scoring Platform is running' });
});

app.listen(port, () => {
  console.log('🏆 Competition Scoring Platform');
  console.log('='.repeat(50));
  console.log(`🌐 Server running at: http://localhost:${port}`);
  console.log('🔐 Privacy-preserving judge scoring');
  console.log('⚡ Powered by FHE technology');
  console.log('='.repeat(50));
  console.log('✨ Platform is ready! Open the URL above in your browser.');
});