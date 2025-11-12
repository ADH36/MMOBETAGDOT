// Admin Panel JavaScript

let updateInterval;
let canvas;
let ctx;

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    canvas = document.getElementById('gameMap');
    ctx = canvas.getContext('2d');
    
    updateServerStatus();
    loadStats();
    loadPlayers();
    loadChatHistory();
    drawGameMap();
    
    // Auto-refresh every 2 seconds
    updateInterval = setInterval(() => {
        loadStats();
        loadPlayers();
    }, 2000);
    
    // Auto-refresh chat every 5 seconds
    setInterval(loadChatHistory, 5000);
    
    // Update map every second
    setInterval(drawGameMap, 1000);
});

// Server status
function updateServerStatus() {
    fetch('/api/stats')
        .then(response => response.json())
        .then(data => {
            document.getElementById('serverStatus').textContent = 'Server Online';
            document.getElementById('statusIndicator').classList.add('online');
        })
        .catch(error => {
            document.getElementById('serverStatus').textContent = 'Server Offline';
            document.getElementById('statusIndicator').classList.remove('online');
            document.getElementById('statusIndicator').classList.add('offline');
        });
}

// Load server statistics
function loadStats() {
    fetch('/api/stats')
        .then(response => response.json())
        .then(data => {
            document.getElementById('currentPlayers').textContent = data.currentPlayers;
            document.getElementById('totalConnections').textContent = data.totalConnections;
            document.getElementById('messagesPerSec').textContent = data.messagesPerSecond;
            document.getElementById('uptime').textContent = formatUptime(data.uptime);
        })
        .catch(error => console.error('Error loading stats:', error));
}

// Load players list
function loadPlayers() {
    fetch('/api/players')
        .then(response => response.json())
        .then(data => {
            const playersList = document.getElementById('playersList');
            
            if (data.players.length === 0) {
                playersList.innerHTML = '<p class="no-players">No players online</p>';
                return;
            }
            
            playersList.innerHTML = '';
            data.players.forEach(player => {
                const playerDiv = document.createElement('div');
                playerDiv.className = 'player-item';
                playerDiv.innerHTML = `
                    <div class="player-info">
                        <div class="player-name">${escapeHtml(player.username)}</div>
                        <div class="player-id">ID: ${player.id}</div>
                        <div class="player-position">Position: (${Math.round(player.x)}, ${Math.round(player.y)})</div>
                    </div>
                    <div class="player-actions">
                        <button class="btn btn-danger" onclick="kickPlayerById('${player.id}')">Kick</button>
                    </div>
                `;
                playersList.appendChild(playerDiv);
            });
        })
        .catch(error => console.error('Error loading players:', error));
}

// Load chat history
function loadChatHistory() {
    fetch('/api/chat-history?limit=50')
        .then(response => response.json())
        .then(data => {
            const chatHistory = document.getElementById('chatHistory');
            
            if (data.messages.length === 0) {
                chatHistory.innerHTML = '<p class="no-messages">No chat messages yet</p>';
                return;
            }
            
            chatHistory.innerHTML = '';
            data.messages.forEach(msg => {
                const msgDiv = document.createElement('div');
                msgDiv.className = 'chat-message';
                
                const timestamp = new Date(msg.timestamp).toLocaleTimeString();
                
                msgDiv.innerHTML = `
                    <div>
                        <span class="chat-sender">${escapeHtml(msg.username)}</span>
                        <span class="chat-time">${timestamp}</span>
                    </div>
                    <div class="chat-text">${escapeHtml(msg.message)}</div>
                `;
                chatHistory.appendChild(msgDiv);
            });
            
            // Scroll to bottom
            chatHistory.scrollTop = chatHistory.scrollHeight;
        })
        .catch(error => console.error('Error loading chat history:', error));
}

// Draw game map with player positions
function drawGameMap() {
    if (!ctx) return;
    
    // Clear canvas
    ctx.fillStyle = '#1a1a2e';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    // Draw grid
    ctx.strokeStyle = '#2a2a3e';
    ctx.lineWidth = 1;
    
    for (let x = 0; x < canvas.width; x += 50) {
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, canvas.height);
        ctx.stroke();
    }
    
    for (let y = 0; y < canvas.height; y += 50) {
        ctx.beginPath();
        ctx.moveTo(0, y);
        ctx.lineTo(canvas.width, y);
        ctx.stroke();
    }
    
    // Draw border
    ctx.strokeStyle = '#667eea';
    ctx.lineWidth = 2;
    ctx.strokeRect(1, 1, canvas.width - 2, canvas.height - 2);
    
    // Draw title
    ctx.fillStyle = '#ffffff';
    ctx.font = '14px Arial';
    ctx.fillText('Game World (1280x720 scaled to fit)', 10, 20);
    
    // Fetch and draw players
    fetch('/api/players')
        .then(response => response.json())
        .then(data => {
            data.players.forEach(player => {
                // Scale coordinates from game world (1280x720) to canvas (600x400)
                const scaleX = canvas.width / 1280;
                const scaleY = canvas.height / 720;
                
                const x = player.x * scaleX;
                const y = player.y * scaleY;
                
                // Draw player dot
                ctx.fillStyle = '#10b981';
                ctx.beginPath();
                ctx.arc(x, y, 5, 0, 2 * Math.PI);
                ctx.fill();
                
                // Draw player name
                ctx.fillStyle = '#ffffff';
                ctx.font = '10px Arial';
                ctx.fillText(player.username, x + 8, y + 3);
            });
        })
        .catch(error => console.error('Error drawing players:', error));
}

// Broadcast message to all players
function broadcastMessage() {
    const input = document.getElementById('broadcastInput');
    const message = input.value.trim();
    
    if (!message) {
        alert('Please enter a message');
        return;
    }
    
    fetch('/api/broadcast', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('Broadcast sent successfully!');
            input.value = '';
            loadChatHistory();
        }
    })
    .catch(error => {
        console.error('Error sending broadcast:', error);
        alert('Failed to send broadcast');
    });
}

// Kick player by ID
function kickPlayerById(playerId) {
    if (!playerId) {
        playerId = document.getElementById('kickPlayerId').value.trim();
    }
    
    if (!playerId) {
        alert('Please enter a player ID');
        return;
    }
    
    if (!confirm(`Are you sure you want to kick player ${playerId}?`)) {
        return;
    }
    
    fetch('/api/kick', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playerId })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert(data.message);
            document.getElementById('kickPlayerId').value = '';
            loadPlayers();
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error kicking player:', error);
        alert('Failed to kick player');
    });
}

// Utility function to format uptime
function formatUptime(seconds) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    
    if (hours > 0) {
        return `${hours}h ${minutes}m ${secs}s`;
    } else if (minutes > 0) {
        return `${minutes}m ${secs}s`;
    } else {
        return `${secs}s`;
    }
}

// Utility function to escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Kick player function for button
window.kickPlayer = kickPlayerById;
window.broadcastMessage = broadcastMessage;
window.loadChatHistory = loadChatHistory;
