# Combat and World System Documentation

This document describes the combat system, skill system, and world features added to the MMO 2D Game.

## World System

### Multiple Worlds
The game now supports multiple world types:
- **Jungle World**: Dark green environment with trees and bushes
- **Village World**: Brown/tan environment with houses and fences

### World Features
- Randomly generated decorations for each world type
- Dynamic world switching (press **Tab** to toggle between worlds)
- Each world has unique visual theme and decorations
- Camera follows the player smoothly in all worlds

### World Decorations

#### Jungle Decorations
- **Trees**: Brown trunks with green foliage (15 per world)
- **Bushes**: Small green bushes scattered around (20 per world)

#### Village Decorations
- **Houses**: Small buildings with roofs and doors (5 per world)
- **Fences**: Wooden fence posts (10 per world)

## Combat System

### Basic Attack
- **Key**: Space bar
- **Cooldown**: 1.0 second (class-dependent)
- **Damage**: Base damage + Strength stat
- **Visual Effect**: Yellow/orange flash at attack position

#### Class Attack Damage
- **Warrior**: 15 base + 15 strength = 30 total
- **Mage**: 5 base + 5 strength = 10 total
- **Rogue**: 12 base + 8 strength = 20 total
- **Archer**: 10 base + 10 strength = 20 total

### Skills System

Each character class has 2 unique skills that can be cast using number keys 1, 2, and 3.

#### Warrior Skills
1. **Power Slash** (Key: 1)
   - Base Damage: 30
   - Mana Cost: 10
   - Cooldown: 3.0s
   - Effect: Red slash
   
2. **Charge** (Key: 2)
   - Base Damage: 25
   - Mana Cost: 15
   - Cooldown: 5.0s
   - Effect: Orange rush

#### Mage Skills
1. **Fireball** (Key: 1)
   - Base Damage: 40
   - Mana Cost: 20
   - Cooldown: 2.5s
   - Effect: Orange fireball
   
2. **Ice Shard** (Key: 2)
   - Base Damage: 35
   - Mana Cost: 18
   - Cooldown: 3.0s
   - Effect: Blue ice shard

#### Rogue Skills
1. **Backstab** (Key: 1)
   - Base Damage: 45
   - Mana Cost: 12
   - Cooldown: 4.0s
   - Effect: Gray strike
   
2. **Poison Dart** (Key: 2)
   - Base Damage: 20
   - Mana Cost: 10
   - Cooldown: 2.0s
   - Effect: Green dart

#### Archer Skills
1. **Multi-Shot** (Key: 1)
   - Base Damage: 35
   - Mana Cost: 15
   - Cooldown: 3.0s
   - Effect: Brown arrows
   
2. **Explosive Arrow** (Key: 2)
   - Base Damage: 40
   - Mana Cost: 20
   - Cooldown: 5.0s
   - Effect: Orange explosion

### Skill Mechanics
- Skills consume mana when cast
- Each skill has a cooldown period
- Skills cannot be cast if:
  - Not enough mana
  - Skill is on cooldown
- Visual effects appear when skills are cast

## Skill Upgrade System

### Accessing Skill Upgrades
- Press **PageUp** to open/close the Skill Upgrade UI
- The UI shows all available skills with their current stats

### Skill Levels
- Each skill starts at Level 1
- Maximum skill level: 5
- Skills can be upgraded one level at a time

### Upgrade Benefits (Per Level)
- **Damage**: +5 per level
- **Mana Cost**: +2 per level (skills become more expensive)
- **Cooldown**: Unchanged

### Example Progression
Power Slash (Warrior):
- Level 1: 30 damage, 10 mana
- Level 2: 35 damage, 12 mana
- Level 3: 40 damage, 14 mana
- Level 4: 45 damage, 16 mana
- Level 5: 50 damage, 18 mana (MAX)

## Combat UI

### Health and Mana Bars
Located in the top-left corner showing:
- Current/Max Health
- Current/Max Mana
- Visual progress bars
- Real-time updates

### Skill Hotbar
Located at the bottom of the screen showing:
- Skill name
- Cooldown timer (or "Ready" when available)
- Key binding (1, 2, or 3)
- Individual panels for each skill

## Controls Summary

### Movement
- **W / Up Arrow**: Move up
- **S / Down Arrow**: Move down
- **A / Left Arrow**: Move left
- **D / Right Arrow**: Move right

### Combat
- **Space**: Basic attack
- **1**: Cast Skill 1
- **2**: Cast Skill 2
- **3**: Cast Skill 3

### UI
- **Enter**: Open/close chat
- **PageUp**: Open/close Skill Upgrade UI
- **Tab**: Toggle between Jungle and Village worlds

## Technical Details

### Character Stats
All combat calculations are based on character stats:
- **Health**: Determines survivability
- **Mana**: Resource for casting skills
- **Strength**: Increases basic attack damage
- **Intelligence**: (Future use for spell power)
- **Agility**: (Future use for critical hits)

### Visual Effects
- Effects use ColorRect nodes for simple, performant visuals
- Each effect has a lifetime of 0.5 seconds
- Effects fade out and scale up during their lifetime
- Effect colors match skill/attack type

### Camera System
- Camera smoothly follows the local player
- Updates every frame in `_process()`
- Centered on player position
- No zoom or rotation implemented yet

## Future Enhancements

Potential additions:
1. **Damage Numbers**: Show floating damage text when hitting enemies
2. **Enemy NPCs**: Add monsters to fight
3. **Experience System**: Gain XP from combat to level up
4. **Equipment**: Add weapons and armor that affect stats
5. **More Skills**: Additional skills per class (up to 10 total)
6. **Skill Trees**: Choose specializations within each class
7. **Status Effects**: Buffs, debuffs, DoTs, HoTs
8. **Combo System**: Chain attacks and skills for bonuses
9. **World Portals**: Interactive points to travel between worlds
10. **Save Skills**: Persist skill levels in character save files

## Troubleshooting

### Skills Not Working
- Check if you have enough mana
- Verify skill is not on cooldown
- Ensure you're pressing the correct number key

### Visual Effects Not Appearing
- Effects spawn at player position + offset
- They last only 0.5 seconds
- Check that AttackEffect.tscn exists

### World Not Changing
- Press Tab key to toggle worlds
- Check console for any errors
- Verify decorations are being created

### UI Not Visible
- Health/Mana bars are in top-left
- Skill bar is at bottom
- PageUp toggles skill upgrade UI
- Check that CombatUI is added to GameWorld scene

## Code Structure

### New Files
- `scripts/Skill.gd` - Skill resource class
- `scripts/AttackEffect.gd` - Visual effect controller
- `scripts/CombatUI.gd` - Combat UI controller
- `scripts/SkillUpgradeUI.gd` - Skill upgrade interface
- `scripts/WorldDecoration.gd` - World decoration generator
- `scenes/AttackEffect.tscn` - Effect scene
- `scenes/CombatUI.tscn` - Combat UI scene
- `scenes/SkillUpgradeUI.tscn` - Upgrade UI scene

### Modified Files
- `scripts/Player.gd` - Added combat input handling
- `scripts/GameWorld.gd` - Added world system and camera following
- `scripts/CharacterData.gd` - Added combat stats and skills
- `scenes/GameWorld.tscn` - Added UI and decorations
- `project.godot` - Added input actions for combat

## Performance Notes

- Decorations are created once when world loads
- Effects are removed after 0.5 seconds automatically
- UI updates every frame but only when visible
- Cooldowns are tracked per-frame in delta time
- No physics calculations for effects (Node2D only)
