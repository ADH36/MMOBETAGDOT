# MMOBETAGDOT - 2D MMORPG Game

A multiplayer 2D MMORPG built with Godot Engine 4.5.1 and Node.js server with real-time WebSocket communication and an admin monitoring panel.

## 🎮 Features

### Client (Godot 4.5.1)
- **Character System**: Create and customize your own 2D character
- **Main Menu**: Navigate between New Game, Load Character, and Exit
- **Character Creation**: 
  - Choose from 4 classes (Warrior, Mage, Rogue, Archer)
  - Customize appearance (skin tone, hair color)
  - Live character preview
  - Save and load character data
- **Real-time Multiplayer**: Multiple players can join and interact in the same world
- **Player Movement**: WASD or Arrow keys for character movement
- **Real-time Chat**: Press Enter to open chat and communicate with other players
- **Player Synchronization**: See other players moving in real-time with their custom appearances
- **Modern UI**: Clean login screen and in-game HUD

### Server (Node.js)
- **WebSocket Server**: Built with `ws` library for real-time communication
- **Player Management**: Authentication, position tracking, and session management
- **Chat System**: Real-time chat messaging with message history
- **Database**: SQLite database for persistent data storage
- **RESTful API**: Admin endpoints for server management

### Admin Panel
- **📊 Real-time Statistics**: Monitor current players, total connections, messages/sec, and uptime
- **👥 Player Monitoring**: View all online players with their positions
- **🗺️ Game World Visualization**: Live map showing player positions
- **💬 Chat History**: View all chat messages
- **🎛️ Control Panel**: 
  - Broadcast messages to all players
  - Kick players from the server
  - Monitor server health

## 🚀 Getting Started

### Prerequisites
- **Godot Engine 4.5.1** (or compatible 4.x version)
- **Node.js** (v16 or higher)
- **npm** (Node Package Manager)

### Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/ADH36/MMOBETAGDOT.git
cd MMOBETAGDOT
```

#### 2. Set Up the Server

```bash
cd server
npm install
```

#### 3. Start the Server

```bash
npm start
```

The server will start on `http://localhost:3000`

For development with auto-restart:
```bash
npm run dev
```

#### 4. Open the Admin Panel

Open your web browser and navigate to:
```
http://localhost:3000
```

#### 5. Launch the Game Client

1. Open Godot Engine 4.5.1
2. Click "Import" and select the `project.godot` file in the repository root
3. Once imported, click "Run" (F5) to start the game
4. You'll see the Main Menu with options:
   - **New Game**: Create a new character
   - **Load Character**: Load a previously saved character
   - **Exit**: Close the game
5. Create or load your character
6. Enter server connection details and connect
7. You should now be in the game world with your custom character!

## 🎯 How to Play

### Controls
- **W / Up Arrow**: Move up
- **S / Down Arrow**: Move down
- **A / Left Arrow**: Move left
- **D / Right Arrow**: Move right
- **Enter**: Open/close chat

### Character Creation
1. **Choose Your Class**: Select from Warrior, Mage, Rogue, or Archer
   - Each class has unique stats and appearance
2. **Customize Appearance**: 
   - Adjust skin tone (4 options)
   - Change hair color (6 options)
3. **Preview Your Character**: See your character in real-time as you customize
4. **Save Your Character**: Characters are automatically saved and can be loaded later

### Multiplayer
1. Start the server first
2. Launch multiple game clients
3. Each client can create or load their character
4. Connect to the server with different usernames
5. All players will see each other moving in real-time with their custom appearances

## 🏗️ Project Structure

```
MMOBETAGDOT/
├── project.godot          # Godot project configuration
├── scenes/                    # Godot scene files
│   ├── Main.tscn             # Main game scene
│   ├── MainMenu.tscn         # Main menu interface
│   ├── CharacterCreation.tscn # Character creation screen
│   ├── LoadCharacter.tscn    # Load character screen
│   ├── Player.tscn           # Player character scene
│   ├── GameWorld.tscn        # Game world scene
│   ├── LoginUI.tscn          # Login interface
│   └── ChatUI.tscn           # Chat interface
├── scripts/                   # GDScript files
│   ├── MainGame.gd           # Main game controller
│   ├── MainMenu.gd           # Main menu controller
│   ├── CharacterCreation.gd  # Character creation controller
│   ├── LoadCharacter.gd      # Load character controller
│   ├── CharacterData.gd      # Character data resource
│   ├── NetworkManager.gd     # WebSocket client manager
│   ├── Player.gd             # Player controller
│   ├── GameWorld.gd          # World manager
│   ├── LoginUI.gd            # Login UI controller
│   └── ChatUI.gd             # Chat UI controller
├── server/                # Node.js server
│   ├── server.js         # Main server file
│   ├── database.js       # Database manager
│   ├── package.json      # Node dependencies
│   └── public/           # Admin panel files
│       ├── index.html    # Admin panel HTML
│       ├── style.css     # Admin panel styles
│       └── admin.js      # Admin panel JavaScript
└── README.md             # This file
```

## 🔧 Configuration

### Server Configuration

Edit `server/.env` (create from `.env.example`):
```env
PORT=3000
DB_PATH=./game.db
MAX_PLAYERS=100
TICK_RATE=60
```

### Client Configuration

Edit the server URL in `scripts/NetworkManager.gd`:
```gdscript
var server_url = "ws://localhost:3000"
```

For remote server connections, change to:
```gdscript
var server_url = "ws://your-server-ip:3000"
```

### Character System

The game features a comprehensive character system with:

#### Character Classes
- **Warrior**: High health (150) and strength (15). Tank class for close combat.
- **Mage**: High mana (100) and intelligence (15). Caster class for magic.
- **Rogue**: High agility (15) and speed. Stealth and critical damage specialist.
- **Archer**: Balanced stats. Ranged combat specialist.

#### Character Customization
- **4 Skin Tones**: From light to dark
- **6 Hair Colors**: Black, Brown, Blonde, Red, White, Gray
- **Class-based Outfit Colors**: Each class has a unique color scheme

#### Save System
Characters are saved locally in the user data directory:
- Up to 3 save slots available
- Each save stores: name, class, appearance, stats, and timestamps
- Load any saved character to continue playing
- Delete characters you no longer need

For detailed information, see [CHARACTER_SYSTEM.md](CHARACTER_SYSTEM.md)

## 📡 API Endpoints

### Admin API

- `GET /api/stats` - Get server statistics
- `GET /api/players` - Get list of online players
- `GET /api/chat-history?limit=50` - Get chat message history
- `POST /api/broadcast` - Broadcast message to all players
- `POST /api/kick` - Kick a player from the server

## 🛠️ Development

### Adding New Features

1. **New Game Features**: Edit scripts in `/scripts` and scenes in `/scenes`
2. **Server Features**: Edit `server/server.js`
3. **Admin Panel Features**: Edit files in `server/public/`

### Database Schema

The server uses SQLite with the following tables:

- `players`: Player information and login history
- `chat_messages`: Chat message history
- `game_events`: Game events and logs

## 🐛 Troubleshooting

### "Failed to connect to server"
- Ensure the Node.js server is running
- Check that the server URL in NetworkManager.gd matches your server address
- Verify firewall settings allow WebSocket connections on port 3000

### "No players visible"
- Check the admin panel to see if players are connected
- Ensure both clients are connected to the same server
- Check browser console for WebSocket errors

### "Admin panel not loading"
- Verify server is running on the correct port
- Check browser console for JavaScript errors
- Try clearing browser cache

## 📝 License

MIT License - Feel free to use this project for learning or commercial purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Support

For issues and questions, please open an issue on GitHub.

## 🎓 Learn More

- [Godot Engine Documentation](https://docs.godotengine.org/)
- [WebSocket Protocol](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)
- [Node.js Documentation](https://nodejs.org/docs/)

## 🌟 Acknowledgments

Built with:
- Godot Engine 4.5.1
- Node.js & Express
- WebSocket (ws library)
- SQLite3

---

**Happy Gaming! 🎮**