# Testing Guide for NPCs, Monsters, and Currency System

This document provides testing procedures for the newly implemented AI NPCs, monsters, hunting system, and currency features.

## Prerequisites

1. Godot Engine 4.5.1 installed
2. Project opened in Godot
3. Node.js server running (for multiplayer testing, optional)

## New Features to Test

### 1. Currency System Testing

**Test 1.1: Currency UI Display**
- [ ] Launch the game and load a character
- [ ] Verify Currency UI appears in the top-right corner
- [ ] Verify it shows "💰 Gold: 0" and "💎 Gems: 0" initially
- [ ] Verify the panel is visible and readable

**Test 1.2: Gold Collection from Monsters**
- [ ] Kill a monster (see Monster Testing below)
- [ ] Verify gold amount increases in the Currency UI
- [ ] Note the amount received (should be between monster's min/max drop)
- [ ] Kill multiple monsters
- [ ] Verify gold accumulates correctly

**Test 1.3: Currency Persistence**
- [ ] Collect some gold by killing monsters
- [ ] Note the gold amount
- [ ] Exit the game completely
- [ ] Relaunch the game and load the same character
- [ ] Verify gold amount is preserved

**Test 1.4: Currency Manager Functions**
- [ ] Check console output when killing monsters
- [ ] Verify messages like "Added X gold. Total: Y"
- [ ] Verify currency saves automatically after each change

### 2. Monster System Testing

**Test 2.1: Monster Spawning**
- [ ] Enter Jungle world
- [ ] Verify 5 "Jungle Slime" monsters spawn (green colored)
- [ ] Verify 1 "Forest Guardian" elite monster spawns (orange colored)
- [ ] Enter Village world (press Tab)
- [ ] Verify 3 "Bandit" monsters spawn
- [ ] Verify all monsters have name labels above them
- [ ] Verify all monsters have health bars above name labels

**Test 2.2: Monster AI - Idle/Patrol**
- [ ] Stand far from monsters (>150 units away)
- [ ] Observe monsters moving randomly (patrol state)
- [ ] Verify monsters switch between idle and patrol states
- [ ] Verify movement is smooth

**Test 2.3: Monster AI - Detection and Chase**
- [ ] Approach a monster slowly
- [ ] Verify monster starts chasing when within ~150 units
- [ ] Verify monster moves faster when chasing
- [ ] Run away from the monster
- [ ] Verify monster continues chasing while in range
- [ ] Move far enough away (>150 units)
- [ ] Verify monster returns to patrol/idle state

**Test 2.4: Monster Attack**
- [ ] Let a monster get close to you (within ~40 units)
- [ ] Verify monster attacks (check console for "attacks for X damage!")
- [ ] Verify your character's health decreases (shown in Combat UI)
- [ ] Verify monster has attack cooldown (~1.5 seconds between attacks)

**Test 2.5: Monster Health System**
- [ ] Attack a monster with Space (basic attack)
- [ ] Verify monster's health bar decreases
- [ ] Verify health bar color changes:
  - Green when > 50% health
  - Yellow when 25-50% health
  - Red when < 25% health
- [ ] Verify damage numbers in console

**Test 2.6: Monster Death and Gold Drop**
- [ ] Kill a monster by reducing health to 0
- [ ] Verify monster becomes invisible
- [ ] Verify gold is added to your total
- [ ] Check console for "died! Dropped X gold" message
- [ ] Verify gold amount is between the monster's min/max range

**Test 2.7: Monster Respawn**
- [ ] After killing a monster, wait 10 seconds
- [ ] Verify monster respawns at original location
- [ ] Verify monster has full health
- [ ] Verify monster returns to patrol/idle behavior

**Test 2.8: Different Monster Types**
- [ ] Compare basic monsters (Slimes/Bandits) to elite (Forest Guardian)
- [ ] Verify elite has:
  - Orange color
  - More health (120 vs 50)
  - Higher damage (10 vs 5)
  - Higher gold drops (10-20 vs 2-8 for slimes)

**Test 2.9: Combat Range Testing**
- [ ] Attack monsters with basic attack (Space)
- [ ] Verify attacks only hit monsters within ~60 units
- [ ] Use skills (1, 2 keys)
- [ ] Verify skills hit monsters within ~80 units

### 3. NPC System Testing

**Test 3.1: NPC Spawning**
- [ ] Enter Jungle world
- [ ] Verify "Jungle Explorer" NPC spawns (gold/yellow colored)
- [ ] Enter Village world (press Tab)
- [ ] Verify "Village Merchant" spawns (purple colored)
- [ ] Verify "Friendly Villager" spawns (blue-gray colored)
- [ ] Verify all NPCs have name labels

**Test 3.2: NPC AI - Movement**
- [ ] Observe NPCs from a distance
- [ ] Verify NPCs wander around randomly
- [ ] Verify NPCs switch between idle and walking states
- [ ] Verify NPCs move slower than monsters (~50 speed)

**Test 3.3: NPC Interaction - Detection**
- [ ] Approach an NPC
- [ ] Verify "[E] Talk" hint appears when close (~50 units)
- [ ] Move away from NPC
- [ ] Verify interaction hint disappears

**Test 3.4: NPC Interaction - Dialogue**
- [ ] Approach "Jungle Explorer" NPC
- [ ] Press E (or Enter/ui_accept)
- [ ] Check console for dialogue output:
  - "=== QUEST GIVER: Jungle Explorer ==="
  - The dialogue text
  - "Quests coming soon!"
- [ ] Repeat for "Village Merchant" (should show shop message)
- [ ] Repeat for "Friendly Villager" (should show generic message)

**Test 3.5: NPC Interaction Cooldown**
- [ ] Interact with an NPC
- [ ] Immediately try to interact again
- [ ] Verify there's a 1-second cooldown between interactions

**Test 3.6: NPC Types Verification**
- [ ] Verify Merchant NPCs are purple colored
- [ ] Verify Quest Giver NPCs are gold colored
- [ ] Verify Generic NPCs are blue-gray colored

### 4. Monster Hunting System Testing

**Test 4.1: Basic Attack vs Monsters**
- [ ] Stand near a monster
- [ ] Press Space to attack
- [ ] Verify attack effect appears
- [ ] Verify monster takes damage
- [ ] Verify attack has 1-second cooldown
- [ ] Verify console shows damage dealt

**Test 4.2: Skills vs Monsters**
- [ ] Stand near a monster
- [ ] Press 1 to use first skill
- [ ] Verify monster takes skill damage
- [ ] Verify mana is consumed
- [ ] Verify skill cooldown works
- [ ] Repeat with skill 2
- [ ] Verify skills deal more damage than basic attacks

**Test 4.3: Multiple Monster Targeting**
- [ ] Position yourself near multiple monsters
- [ ] Use area attack/skill
- [ ] Verify all monsters in range take damage

**Test 4.4: Player Taking Damage**
- [ ] Let a monster attack you
- [ ] Check Combat UI for health decrease
- [ ] Verify console message: "PlayerName took X damage!"
- [ ] Continue until health reaches 0
- [ ] Check console for "has been defeated!" message

**Test 4.5: Gold Farming**
- [ ] Kill 5 monsters in a row
- [ ] Track total gold earned
- [ ] Verify each monster drops gold
- [ ] Verify gold varies based on monster type
- [ ] Calculate average gold per monster

### 5. World-Specific Entity Testing

**Test 5.1: Jungle World Entities**
- [ ] Switch to Jungle world
- [ ] Verify spawned entities:
  - 5 Jungle Slimes (basic, green)
  - 1 Forest Guardian (elite, orange)
  - 1 Jungle Explorer (quest giver)
- [ ] Verify appropriate difficulty for jungle theme

**Test 5.2: Village World Entities**
- [ ] Switch to Village world
- [ ] Verify spawned entities:
  - 3 Bandits (basic)
  - 1 Village Merchant (merchant)
  - 1 Friendly Villager (generic)
- [ ] Verify appropriate NPCs for village setting

**Test 5.3: World Switching Entity Cleanup**
- [ ] Note positions of monsters/NPCs in Jungle
- [ ] Switch to Village world (Tab key)
- [ ] Verify all Jungle monsters/NPCs are removed
- [ ] Verify new Village entities spawn
- [ ] Switch back to Jungle
- [ ] Verify Jungle entities respawn (may be in different positions)

### 6. Integration Testing

**Test 6.1: Complete Gameplay Loop**
- [ ] Start game with new character
- [ ] Enter game world
- [ ] Verify starting with 0 gold
- [ ] Find and kill a monster
- [ ] Verify gold is collected
- [ ] Talk to an NPC
- [ ] Verify interaction works
- [ ] Switch worlds
- [ ] Verify new entities spawn
- [ ] Kill monsters in new world
- [ ] Verify more gold is collected
- [ ] Exit and reload game
- [ ] Verify gold is preserved

**Test 6.2: Combat Flow**
- [ ] Let a monster detect and chase you
- [ ] Fight back with basic attacks
- [ ] Use skills when available
- [ ] Monitor health and mana
- [ ] Kill the monster
- [ ] Collect gold reward
- [ ] Wait for monster respawn
- [ ] Repeat hunt

**Test 6.3: Resource Management**
- [ ] Fight monsters using both attacks and skills
- [ ] Monitor mana consumption
- [ ] Verify skills can't be used without enough mana
- [ ] Verify health decreases when taking damage
- [ ] Plan skill usage for maximum efficiency

## Performance Testing

**Test 7.1: Multiple Monsters**
- [ ] Have 5+ monsters chasing you simultaneously
- [ ] Verify game runs smoothly
- [ ] Verify all monster AI functions correctly
- [ ] Verify no lag or stuttering

**Test 7.2: Repeated World Switching**
- [ ] Switch between worlds 10 times rapidly
- [ ] Verify entities spawn/despawn correctly each time
- [ ] Verify no memory leaks or crashes
- [ ] Verify currency is maintained

## Known Features/Limitations

1. **Currency**: Only gold drops from monsters; gems are for future shop purchases
2. **NPC Dialogue**: Currently outputs to console; full dialogue UI coming later
3. **Player Death**: Player can reach 0 health but doesn't respawn yet (planned feature)
4. **Monster Drops**: Only gold currently; items/equipment planned for future
5. **Quests**: Quest system planned but not yet implemented
6. **Shops**: Merchant shops planned but not yet implemented

## Success Criteria

All test cases should pass with:
- Smooth monster AI behavior
- Correct gold drops and accumulation
- Working NPC interactions
- Proper entity spawning per world
- Currency persistence across sessions
- No crashes or major bugs

## Bug Reporting

When reporting bugs, include:
- Test case number
- Steps to reproduce
- Expected result
- Actual result
- Console output
- Screenshots if applicable
- Godot version and OS
