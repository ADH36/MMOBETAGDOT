const sqlite3 = require('sqlite3').verbose();
const path = require('path');

class Database {
  constructor() {
    this.db = new sqlite3.Database(path.join(__dirname, 'game.db'), (err) => {
      if (err) {
        console.error('Error opening database:', err);
      } else {
        console.log('Database connected');
        this.initializeTables();
      }
    });
  }
  
  initializeTables() {
    // Players table
    this.db.run(`
      CREATE TABLE IF NOT EXISTS players (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        first_login DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_login DATETIME DEFAULT CURRENT_TIMESTAMP,
        total_play_time INTEGER DEFAULT 0
      )
    `);
    
    // Chat messages table
    this.db.run(`
      CREATE TABLE IF NOT EXISTS chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id TEXT,
        username TEXT,
        message TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    `);
    
    // Game events table
    this.db.run(`
      CREATE TABLE IF NOT EXISTS game_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_type TEXT,
        player_id TEXT,
        details TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
  }
  
  addPlayer(playerId, username) {
    this.db.run(
      `INSERT OR REPLACE INTO players (id, username, last_login) VALUES (?, ?, CURRENT_TIMESTAMP)`,
      [playerId, username],
      (err) => {
        if (err) console.error('Error adding player:', err);
      }
    );
  }
  
  updatePlayerLogout(playerId) {
    this.db.run(
      `UPDATE players SET last_login = CURRENT_TIMESTAMP WHERE id = ?`,
      [playerId],
      (err) => {
        if (err) console.error('Error updating player logout:', err);
      }
    );
  }
  
  addChatMessage(playerId, username, message) {
    this.db.run(
      `INSERT INTO chat_messages (player_id, username, message) VALUES (?, ?, ?)`,
      [playerId, username, message],
      (err) => {
        if (err) console.error('Error adding chat message:', err);
      }
    );
  }
  
  getChatHistory(limit, callback) {
    this.db.all(
      `SELECT * FROM chat_messages ORDER BY timestamp DESC LIMIT ?`,
      [limit],
      (err, rows) => {
        if (err) {
          console.error('Error getting chat history:', err);
          callback([]);
        } else {
          callback(rows.reverse());
        }
      }
    );
  }
  
  logEvent(eventType, playerId, details) {
    this.db.run(
      `INSERT INTO game_events (event_type, player_id, details) VALUES (?, ?, ?)`,
      [eventType, playerId, JSON.stringify(details)],
      (err) => {
        if (err) console.error('Error logging event:', err);
      }
    );
  }
  
  getPlayerStats(callback) {
    this.db.all(
      `SELECT COUNT(*) as total_players, 
              COUNT(DISTINCT DATE(last_login)) as active_days 
       FROM players`,
      (err, rows) => {
        if (err) {
          console.error('Error getting player stats:', err);
          callback({ total_players: 0, active_days: 0 });
        } else {
          callback(rows[0]);
        }
      }
    );
  }
  
  close() {
    this.db.close((err) => {
      if (err) {
        console.error('Error closing database:', err);
      } else {
        console.log('Database connection closed');
      }
    });
  }
}

module.exports = Database;
