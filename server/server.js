const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const path = require('path');
const cors = require('cors');
const Database = require('./database');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Initialize database
const db = new Database();

// Game state
const players = new Map();
const gameStats = {
  totalConnections: 0,
  currentPlayers: 0,
  messagesPerSecond: 0,
  startTime: Date.now()
};

// Message rate tracking
let messageCount = 0;
setInterval(() => {
  gameStats.messagesPerSecond = messageCount;
  messageCount = 0;
}, 1000);

// WebSocket connection handler for game clients
wss.on('connection', (ws) => {
  let playerId = null;
  gameStats.totalConnections++;
  
  console.log('New client connected');
  
  ws.on('message', (data) => {
    messageCount++;
    
    try {
      const message = JSON.parse(data.toString());
      handleClientMessage(ws, message);
    } catch (error) {
      console.error('Error parsing message:', error);
    }
  });
  
  ws.on('close', () => {
    if (playerId && players.has(playerId)) {
      const player = players.get(playerId);
      console.log(`Player disconnected: ${player.username}`);
      
      // Update database
      db.updatePlayerLogout(playerId);
      
      // Notify other players
      broadcastToOthers(playerId, {
        type: 'player_left',
        player_id: playerId
      });
      
      players.delete(playerId);
      gameStats.currentPlayers = players.size;
    }
  });
  
  function handleClientMessage(ws, message) {
    switch (message.type) {
      case 'auth':
        playerId = generatePlayerId();
        const username = message.username || 'Player';
        
        // Create player object
        const player = {
          id: playerId,
          username: username,
          x: 640,
          y: 360,
          ws: ws
        };
        
        players.set(playerId, player);
        gameStats.currentPlayers = players.size;
        
        // Save to database
        db.addPlayer(playerId, username);
        
        // Send authentication success
        ws.send(JSON.stringify({
          type: 'auth_success',
          player_id: playerId
        }));
        
        // Send existing players list
        const playersList = Array.from(players.values())
          .filter(p => p.id !== playerId)
          .map(p => ({
            id: p.id,
            username: p.username,
            x: p.x,
            y: p.y
          }));
        
        ws.send(JSON.stringify({
          type: 'player_list',
          players: playersList
        }));
        
        // Notify other players about new player
        broadcastToOthers(playerId, {
          type: 'player_joined',
          player: {
            id: playerId,
            username: username,
            x: player.x,
            y: player.y
          }
        });
        
        console.log(`Player authenticated: ${username} (${playerId})`);
        break;
        
      case 'move':
        if (playerId && players.has(playerId)) {
          const player = players.get(playerId);
          player.x = message.x || player.x;
          player.y = message.y || player.y;
          
          // Broadcast position to other players
          broadcastToOthers(playerId, {
            type: 'player_moved',
            player_id: playerId,
            x: player.x,
            y: player.y
          });
        }
        break;
        
      case 'chat':
        if (playerId && players.has(playerId)) {
          const player = players.get(playerId);
          const chatMessage = message.message || '';
          
          // Save chat to database
          db.addChatMessage(playerId, player.username, chatMessage);
          
          // Broadcast to all players
          broadcast({
            type: 'chat',
            sender: player.username,
            message: chatMessage
          });
          
          console.log(`Chat from ${player.username}: ${chatMessage}`);
        }
        break;
        
      case 'disconnect':
        ws.close();
        break;
    }
  }
});

// Broadcast to all connected players
function broadcast(message) {
  const data = JSON.stringify(message);
  players.forEach(player => {
    if (player.ws.readyState === WebSocket.OPEN) {
      player.ws.send(data);
    }
  });
}

// Broadcast to all players except one
function broadcastToOthers(excludePlayerId, message) {
  const data = JSON.stringify(message);
  players.forEach(player => {
    if (player.id !== excludePlayerId && player.ws.readyState === WebSocket.OPEN) {
      player.ws.send(data);
    }
  });
}

// Generate unique player ID
function generatePlayerId() {
  return 'player_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

// Admin API endpoints
app.get('/api/stats', (req, res) => {
  const uptime = Math.floor((Date.now() - gameStats.startTime) / 1000);
  
  res.json({
    currentPlayers: gameStats.currentPlayers,
    totalConnections: gameStats.totalConnections,
    messagesPerSecond: gameStats.messagesPerSecond,
    uptime: uptime
  });
});

app.get('/api/players', (req, res) => {
  const playersList = Array.from(players.values()).map(p => ({
    id: p.id,
    username: p.username,
    x: p.x,
    y: p.y
  }));
  
  res.json({ players: playersList });
});

app.post('/api/kick', (req, res) => {
  const { playerId } = req.body;
  
  if (players.has(playerId)) {
    const player = players.get(playerId);
    player.ws.close();
    res.json({ success: true, message: `Player ${player.username} kicked` });
  } else {
    res.status(404).json({ success: false, message: 'Player not found' });
  }
});

app.post('/api/broadcast', (req, res) => {
  const { message } = req.body;
  
  broadcast({
    type: 'chat',
    sender: 'ADMIN',
    message: message
  });
  
  res.json({ success: true, message: 'Broadcast sent' });
});

app.get('/api/chat-history', (req, res) => {
  const limit = parseInt(req.query.limit) || 50;
  db.getChatHistory(limit, (messages) => {
    res.json({ messages });
  });
});

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`MMO Game Server running on port ${PORT}`);
  console.log(`Admin panel: http://localhost:${PORT}`);
  console.log(`WebSocket server: ws://localhost:${PORT}`);
});
