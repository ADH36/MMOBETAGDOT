# NPC and Monster System Documentation

## Overview

This document describes the NPC (Non-Player Character), Monster, and Currency systems implemented in the MMOBETAGDOT game.

## Currency System

### Currency Types

The game features two types of currency:

1. **Gold** (💰) - Free currency
   - Earned by defeating monsters
   - Used for in-game purchases (future feature)
   - Collectable through gameplay
   - Persistent across sessions

2. **Gems** (💎) - Premium currency
   - Intended for shop purchases with real money (future feature)
   - Currently can be added via game mechanics
   - Persistent across sessions

### Currency Manager

The `CurrencyManager` is a global autoload singleton that manages all currency operations:

```gdscript
# Add currency
CurrencyManager.add_gold(amount)
CurrencyManager.add_gems(amount)

# Spend currency
if CurrencyManager.spend_gold(cost):
    # Purchase successful
    pass

# Check current amounts
var current_gold = CurrencyManager.get_gold()
var current_gems = CurrencyManager.get_gems()
```

### Currency UI

The Currency UI is displayed in the top-right corner of the game screen and shows:
- Current gold amount with coin icon
- Current gems amount with gem icon
- Updates in real-time when currency changes

### Persistence

Currency is automatically saved to disk whenever it changes and loaded when the game starts.

## Monster System

### Monster Types

Monsters come in three varieties:

1. **Basic Monsters**
   - Standard enemies
   - Green color
   - Moderate health (50-60)
   - Low damage (5-7)
   - Small gold drops (2-12)
   - Examples: Jungle Slime, Bandit

2. **Elite Monsters**
   - Stronger variants
   - Orange color
   - High health (100-150)
   - Medium damage (10-15)
   - Medium gold drops (10-20)
   - Example: Forest Guardian

3. **Boss Monsters** (Future)
   - Rare powerful enemies
   - Red color
   - Very high health
   - High damage
   - Large gold drops

### Monster Properties

Each monster has:
- **Name**: Display name shown above the monster
- **Type**: basic, elite, or boss
- **Health**: Current and maximum health with visual health bar
- **Damage**: Attack damage dealt to players
- **Speed**: Movement speed (basic: 80, elite: 100)
- **Detection Range**: Distance at which monster detects players (default: 150)
- **Attack Range**: Distance at which monster can attack (default: 40)
- **Gold Drops**: Minimum and maximum gold dropped on death

### Monster AI States

Monsters have sophisticated AI with multiple states:

1. **Idle**
   - Monster stands still
   - Periodically switches to patrol
   - Constantly scans for nearby players

2. **Patrol**
   - Monster walks in a random direction
   - Changes direction every 2-4 seconds
   - Continues scanning for players

3. **Chase**
   - Activated when player enters detection range
   - Monster moves toward player at increased speed
   - Switches to attack when in range

4. **Attack**
   - Monster is within attack range of player
   - Deals damage every 1.5 seconds
   - Returns to chase if player moves away

5. **Dead**
   - Monster becomes invisible
   - Drops gold
   - Starts respawn timer (10 seconds)

### Monster Behavior

- Monsters automatically detect the nearest player within detection range
- Once a player is detected, the monster will chase and attack
- Monsters take damage from player attacks and skills
- Health bars change color based on remaining health:
  - Green: >50% health
  - Yellow: 25-50% health
  - Red: <25% health
- When killed, monsters drop random gold amounts
- Monsters respawn after 10 seconds at their spawn location

### Creating Monsters

Monsters are spawned programmatically in the GameWorld:

```gdscript
var monster = monster_scene.instantiate()
monster.monster_name = "Custom Monster"
monster.monster_type = "elite"
monster.max_health = 100
monster.attack_damage = 10
monster.gold_drop_min = 5
monster.gold_drop_max = 15
monster.global_position = Vector2(x, y)
monsters_container.add_child(monster)
```

## NPC System

### NPC Types

NPCs come in three types with different behaviors and appearances:

1. **Merchant** (Purple)
   - Represents shop keepers
   - Future: Will open shop interface
   - Currently shows merchant dialogue

2. **Quest Giver** (Gold)
   - Provides quests and objectives
   - Future: Will open quest interface
   - Currently shows quest dialogue

3. **Generic** (Blue-gray)
   - Regular villagers and citizens
   - Provides flavor text and lore
   - Shows generic dialogue

### NPC Properties

Each NPC has:
- **Name**: Display name shown above the NPC
- **Type**: merchant, quest_giver, or generic
- **Dialogue**: Text shown when interacting
- **Speed**: Walking speed (slower than monsters)

### NPC AI States

NPCs have simple wandering AI:

1. **Idle**
   - NPC stands still for 2-5 seconds
   - Then switches to walk state

2. **Walk**
   - NPC walks in a random direction
   - Continues for 1.5-3.5 seconds
   - Then returns to idle

### NPC Interaction

Players can interact with NPCs:
- When player is within 50 units of an NPC, "[E] Talk" hint appears
- Press E (or Enter) to interact
- Interaction has 1-second cooldown
- Different dialogue based on NPC type

### Creating NPCs

NPCs are spawned programmatically:

```gdscript
var npc = npc_scene.instantiate()
npc.npc_name = "Custom NPC"
npc.npc_type = "merchant"
npc.dialogue_text = "Welcome to my shop!"
npc.global_position = Vector2(x, y)
npcs_container.add_child(npc)
```

## Monster Hunting System

### Combat Mechanics

Players can fight monsters using:

1. **Basic Attack** (Space)
   - Range: 60 units
   - Damage: Base attack + Strength stat
   - Cooldown: 1 second

2. **Skills** (1, 2, 3 keys)
   - Range: 80 units
   - Damage: Skill base damage + scaling
   - Cost: Mana
   - Cooldown: Varies by skill

### Damage Calculation

- Player attacks check for monsters within range
- Each monster in range takes damage
- Monster health decreases
- Visual health bar updates
- Console logs damage dealt

### Death and Rewards

When a monster dies:
1. Monster becomes invisible
2. Gold is calculated: random amount between min and max
3. Gold is added to player's currency via CurrencyManager
4. Console message shows gold dropped
5. Respawn timer starts (10 seconds)
6. After timer expires, monster respawns with full health

### Player Damage

When monsters attack players:
1. Monster checks if player is in attack range
2. Damage is dealt every 1.5 seconds
3. Player's health decreases
4. Combat UI updates health bar
5. Console shows damage taken
6. At 0 health, "defeated" message shown (respawn coming soon)

## World-Specific Spawns

### Jungle World

Themed around wild nature:
- **Monsters**:
  - 5x Jungle Slime (basic, green, 50 HP, 2-8 gold)
  - 1x Forest Guardian (elite, orange, 120 HP, 10-20 gold)
- **NPCs**:
  - Jungle Explorer (quest giver)

### Village World

Themed around civilization:
- **Monsters**:
  - 3x Bandit (basic, 60 HP, 5-12 gold)
- **NPCs**:
  - Village Merchant (merchant)
  - Friendly Villager (generic)

### World Switching

- Pressing Tab switches between worlds
- All monsters and NPCs from previous world are removed
- New world spawns its entities
- Currency and player stats are preserved

## Future Enhancements

### Planned Features

1. **Currency System**
   - Shop system for spending gold
   - Premium shop for gems
   - Item purchases
   - Skill upgrades with gold

2. **Monster System**
   - Boss monsters with special mechanics
   - Monster variety (different behaviors)
   - Loot tables (items, not just gold)
   - Experience points and leveling
   - Monster levels and scaling

3. **NPC System**
   - Full dialogue system with UI
   - Quest system
   - Shop interfaces
   - NPC reputation system
   - Multiple dialogue options

4. **Hunting System**
   - Quest objectives (kill X monsters)
   - Bounty system
   - Monster tracking
   - Hunting achievements
   - Rare monster spawns

5. **Combat Enhancements**
   - Player respawn system
   - Damage numbers floating text
   - Critical hits
   - Combat animations
   - Sound effects

## Technical Details

### Groups

- Monsters are in "monsters" group
- NPCs are in "npcs" group  
- Players are in "players" group

### Signals

CurrencyManager emits:
- `currency_changed(type: String, amount: int)` - When currency changes

### File Structure

```
scripts/
  ├── Monster.gd         # Monster AI and behavior
  ├── NPC.gd             # NPC AI and interaction
  ├── CurrencyManager.gd # Global currency management
  └── CurrencyUI.gd      # Currency display UI

scenes/
  ├── Monster.tscn       # Monster scene with visuals
  ├── NPC.tscn           # NPC scene with visuals
  └── CurrencyUI.tscn    # Currency UI panel
```

### Performance Considerations

- Monsters only process AI when alive
- Entity detection uses range checks (efficient)
- World switching clears old entities (prevents memory leaks)
- Currency saves are throttled (only on change)

## Code Examples

### Adding Custom Monster to World

```gdscript
func spawn_custom_monster():
    var monster = monster_scene.instantiate()
    monster.monster_name = "Shadow Beast"
    monster.monster_type = "elite"
    monster.max_health = 200
    monster.attack_damage = 15
    monster.move_speed = 100.0
    monster.detection_range = 200.0
    monster.gold_drop_min = 20
    monster.gold_drop_max = 40
    monster.global_position = Vector2(640, 360)
    monsters_container.add_child(monster)
```

### Adding Custom NPC

```gdscript
func spawn_custom_npc():
    var npc = npc_scene.instantiate()
    npc.npc_name = "Wise Sage"
    npc.npc_type = "quest_giver"
    npc.dialogue_text = "Seek the ancient artifact in the forgotten temple."
    npc.global_position = Vector2(400, 300)
    npcs_container.add_child(npc)
```

### Manually Adjusting Currency

```gdscript
# Give player bonus gold
CurrencyManager.add_gold(100)

# Give premium currency (e.g., from achievement)
CurrencyManager.add_gems(10)

# Try to buy something
if CurrencyManager.spend_gold(50):
    print("Purchase successful!")
else:
    print("Not enough gold!")
```
