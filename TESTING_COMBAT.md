# Combat and World System Testing Guide

This document provides step-by-step testing procedures for the new combat and world features.

## Prerequisites

1. Godot Engine 4.5.1 installed
2. Project opened in Godot Editor
3. Node.js server running (optional, for multiplayer testing)

## Test Scenarios

### Test 1: Camera Following

**Objective**: Verify camera smoothly follows the player

**Steps:**
1. Launch the game (F5)
2. Create or load a character
3. Connect to server (or skip for solo testing)
4. Once in game world, use WASD or arrow keys to move
5. Observe the camera movement

**Expected Results:**
- ✓ Camera is centered on the player character
- ✓ Camera moves smoothly with player movement
- ✓ Camera follows player in all directions
- ✓ No camera jitter or lag

---

### Test 2: Basic Attack System

**Objective**: Verify basic attack functionality

**Steps:**
1. Enter the game world with any character class
2. Press **Space** to attack
3. Observe the console output and visual effect
4. Press Space multiple times rapidly
5. Wait 1 second and press Space again

**Expected Results:**
- ✓ Attack visual effect appears in front of player (yellow/orange)
- ✓ Console shows "Attack! Damage: [value]"
- ✓ Damage value matches class stats
- ✓ Attack has 1-second cooldown (rapid presses don't spam attacks)
- ✓ Effect fades out after 0.5 seconds

**Class-Specific Damage:**
- Warrior: 30 damage
- Mage: 10 damage
- Rogue: 20 damage
- Archer: 20 damage

---

### Test 3: Skills System - Warrior

**Objective**: Test Warrior class skills

**Steps:**
1. Create a Warrior character
2. Enter game world
3. Press **1** to use Power Slash
4. Wait for cooldown, press **2** to use Charge
5. Try using skills without enough mana

**Expected Results:**
- ✓ Power Slash: Red effect, 30 damage, costs 10 mana
- ✓ Charge: Orange effect, 25 damage, costs 15 mana
- ✓ Console shows skill name and damage
- ✓ Mana bar decreases when skills are used
- ✓ Skills have cooldowns (3s and 5s respectively)
- ✓ Skills cannot be cast without enough mana

---

### Test 4: Skills System - Mage

**Objective**: Test Mage class skills

**Steps:**
1. Create a Mage character (max mana: 100)
2. Enter game world
3. Press **1** to use Fireball
4. Press **2** to use Ice Shard
5. Use skills until mana is depleted

**Expected Results:**
- ✓ Fireball: Orange effect, 40 damage, costs 20 mana, 2.5s cooldown
- ✓ Ice Shard: Blue effect, 35 damage, costs 18 mana, 3s cooldown
- ✓ Mage has highest mana pool (100)
- ✓ Can cast multiple skills before running out
- ✓ Effects match skill colors

---

### Test 5: Skills System - Rogue

**Objective**: Test Rogue class skills

**Steps:**
1. Create a Rogue character
2. Enter game world
3. Press **1** to use Backstab
4. Press **2** to use Poison Dart

**Expected Results:**
- ✓ Backstab: Gray effect, 45 damage, costs 12 mana, 4s cooldown
- ✓ Poison Dart: Green effect, 20 damage, costs 10 mana, 2s cooldown
- ✓ Backstab has highest damage of Rogue skills
- ✓ Poison Dart has shortest cooldown

---

### Test 6: Skills System - Archer

**Objective**: Test Archer class skills

**Steps:**
1. Create an Archer character
2. Enter game world
3. Press **1** to use Multi-Shot
4. Press **2** to use Explosive Arrow

**Expected Results:**
- ✓ Multi-Shot: Brown effect, 35 damage, costs 15 mana, 3s cooldown
- ✓ Explosive Arrow: Orange effect, 40 damage, costs 20 mana, 5s cooldown
- ✓ Explosive Arrow has longest cooldown
- ✓ Effects appear correctly

---

### Test 7: Combat UI - Health and Mana Bars

**Objective**: Verify UI displays correctly

**Steps:**
1. Enter game world
2. Observe the top-left UI panel
3. Use skills to deplete mana
4. Check that bars update in real-time

**Expected Results:**
- ✓ Health bar shows current/max health (e.g., "150 / 150")
- ✓ Mana bar shows current/max mana (e.g., "100 / 100")
- ✓ Bars are colored (health: green/red, mana: blue)
- ✓ Values update as skills are used
- ✓ UI is visible and readable

---

### Test 8: Combat UI - Skill Hotbar

**Objective**: Verify skill cooldown display

**Steps:**
1. Enter game world
2. Observe the bottom skill bar
3. Cast skill 1 and observe the cooldown
4. Cast skill 2 while skill 1 is on cooldown

**Expected Results:**
- ✓ Bottom bar shows 2 skill panels
- ✓ Each panel shows skill name
- ✓ Each panel shows key binding (1 or 2)
- ✓ "Ready" appears when skill is available
- ✓ Cooldown timer counts down (e.g., "2.5", "2.4", "2.3"...)
- ✓ Timer updates smoothly

---

### Test 9: Skill Upgrade System

**Objective**: Test skill upgrading

**Steps:**
1. Enter game world
2. Press **PageUp** to open Skill Upgrade UI
3. Observe the skill information
4. Click "Upgrade" on a skill
5. Observe the stat changes
6. Upgrade a skill to max level (5)

**Expected Results:**
- ✓ UI opens centered on screen
- ✓ All skills are listed with their stats
- ✓ Current level and max level shown (e.g., "Level: 1 / 5")
- ✓ Damage, mana cost, and cooldown displayed
- ✓ Upgrade button works
- ✓ Stats increase after upgrade (+5 damage, +2 mana)
- ✓ Level counter increases
- ✓ Button shows "Max Level" when at level 5
- ✓ Max level skills cannot be upgraded further
- ✓ Close button works
- ✓ PageUp toggles UI

---

### Test 10: Skill Upgrade - Damage Increase

**Objective**: Verify skill damage increases with level

**Steps:**
1. Note the damage of Power Slash at level 1 (30)
2. Open Skill Upgrade UI (PageUp)
3. Upgrade Power Slash to level 2
4. Note new damage (should be 35)
5. Cast Power Slash and check console

**Expected Results:**
- ✓ Level 1: 30 damage, 10 mana
- ✓ Level 2: 35 damage, 12 mana
- ✓ Level 3: 40 damage, 14 mana
- ✓ Level 4: 45 damage, 16 mana
- ✓ Level 5: 50 damage, 18 mana
- ✓ Console shows increased damage when skill is cast

---

### Test 11: World System - Jungle World

**Objective**: Test jungle world appearance

**Steps:**
1. Enter game world (starts in Jungle by default)
2. Observe the environment
3. Move around to see decorations
4. Count approximate number of decorations

**Expected Results:**
- ✓ Background is dark green
- ✓ Trees visible (brown trunks, green foliage)
- ✓ Bushes visible (small green rectangles)
- ✓ Approximately 15 trees
- ✓ Approximately 20 bushes
- ✓ Decorations are randomly positioned
- ✓ Player can move freely

---

### Test 12: World System - Village World

**Objective**: Test village world appearance

**Steps:**
1. In game world, press **Tab** to switch to Village
2. Observe the environment change
3. Move around to see decorations
4. Identify houses and fences

**Expected Results:**
- ✓ Background changes to brown/tan
- ✓ Houses visible (brown walls, dark roofs, doors)
- ✓ Fences visible (brown posts)
- ✓ Approximately 5 houses
- ✓ Approximately 10 fences
- ✓ Decorations are randomly positioned
- ✓ World transition is smooth

---

### Test 13: World Switching

**Objective**: Test toggling between worlds

**Steps:**
1. Start in Jungle world
2. Press **Tab** to switch to Village
3. Press **Tab** again to switch back to Jungle
4. Repeat several times
5. Observe player position

**Expected Results:**
- ✓ Tab key toggles between worlds
- ✓ Background color changes
- ✓ Decorations change appropriately
- ✓ Player stays at same position
- ✓ No errors in console
- ✓ Transition is immediate
- ✓ Old decorations are removed
- ✓ New decorations are created

---

### Test 14: Visual Effects - Attack

**Objective**: Test attack visual appearance

**Steps:**
1. Enter game world
2. Press Space to attack
3. Observe the effect carefully
4. Attack while moving in different directions

**Expected Results:**
- ✓ Effect appears in front of player
- ✓ Effect is yellow/orange colored
- ✓ Effect is rectangular
- ✓ Effect fades out over 0.5 seconds
- ✓ Effect scales up slightly
- ✓ Effect is removed after lifetime
- ✓ Position is relative to player

---

### Test 15: Visual Effects - Skills

**Objective**: Test skill visual variety

**Steps:**
1. Create a Mage character
2. Cast Fireball (key 1)
3. Wait for cooldown
4. Cast Ice Shard (key 2)
5. Compare the effect colors

**Expected Results:**
- ✓ Fireball has orange effect
- ✓ Ice Shard has blue effect
- ✓ Effects are different colors
- ✓ Both effects fade out
- ✓ Both effects scale up
- ✓ Effect size matches skill specification

---

### Test 16: Resource Management

**Objective**: Test mana consumption and limits

**Steps:**
1. Create a Warrior (low mana: 30)
2. Note starting mana
3. Cast Power Slash (costs 10) - should work
4. Cast Power Slash again (costs 10) - should work
5. Cast Power Slash third time (costs 10) - should work
6. Cast Charge (costs 15) - should fail (not enough mana)

**Expected Results:**
- ✓ Starting mana: 30
- ✓ After 1st cast: 20 mana
- ✓ After 2nd cast: 10 mana
- ✓ After 3rd cast: 0 mana
- ✓ 4th cast fails (not enough mana)
- ✓ No error messages
- ✓ Mana bar reflects changes
- ✓ Skills remain on cooldown even if cast fails

---

### Test 17: Cooldown System

**Objective**: Test skill cooldowns work independently

**Steps:**
1. Enter game world
2. Cast skill 1 (cooldown 3s)
3. Immediately try casting skill 1 again
4. Try casting skill 2 instead
5. Wait for cooldowns to complete

**Expected Results:**
- ✓ Skill 1 cannot be cast while on cooldown
- ✓ Skill 2 can be cast while skill 1 is on cooldown
- ✓ Cooldowns are independent
- ✓ Cooldown timer displays accurately
- ✓ Skills become ready when cooldown reaches 0
- ✓ "Ready" text appears when available

---

### Test 18: Multiplayer - Combat Visibility

**Objective**: Test combat in multiplayer (optional)

**Steps:**
1. Start the Node.js server
2. Launch two game clients
3. Connect both to server
4. In client 1, use attacks and skills
5. Observe from client 2

**Expected Results:**
- ✓ Both players see each other
- ✓ Visual effects are local only (not synced)
- ✓ Each player can use their own combat
- ✓ No interference between players
- ✓ Health/mana bars show correctly for each player

---

### Test 19: All Classes Combat

**Objective**: Verify each class has working combat

**Steps:**
1. Test Warrior: attack + 2 skills
2. Test Mage: attack + 2 skills
3. Test Rogue: attack + 2 skills
4. Test Archer: attack + 2 skills

**Expected Results:**
- ✓ All 4 classes can attack
- ✓ All 4 classes have 2 skills
- ✓ All skills have unique names
- ✓ All skills have different stats
- ✓ All skills have visual effects
- ✓ Damage values are class-appropriate

---

### Test 20: UI Responsiveness

**Objective**: Test UI updates in real-time

**Steps:**
1. Enter game world
2. Rapidly cast multiple skills
3. Observe UI updates
4. Switch worlds while UI is open

**Expected Results:**
- ✓ Health/mana bars update immediately
- ✓ Cooldown timers count down smoothly
- ✓ No UI lag or freezing
- ✓ UI remains visible during world switch
- ✓ Skill Upgrade UI can be opened/closed anytime
- ✓ Multiple UI elements don't conflict

---

## Bug Reporting

If you encounter issues, note:
- Test number
- Steps to reproduce
- Expected vs actual result
- Character class used
- Any console errors
- Godot version

## Performance Notes

Expected performance:
- Smooth 60 FPS in game world
- No lag when switching worlds
- Effects don't impact performance
- UI updates don't cause stuttering

## Summary Checklist

After completing all tests:

- [ ] Camera following works
- [ ] Basic attack works for all classes
- [ ] All 8 skills work correctly
- [ ] Skill upgrades function properly
- [ ] Jungle world loads with decorations
- [ ] Village world loads with decorations
- [ ] World switching works
- [ ] Visual effects appear and animate
- [ ] Health/mana UI updates correctly
- [ ] Skill hotbar shows cooldowns
- [ ] Skill Upgrade UI opens/closes
- [ ] Resource management works
- [ ] Cooldowns work independently
- [ ] All controls respond correctly

## Known Limitations

1. **No Enemy NPCs**: Combat is visual only, no targets to hit
2. **No Damage Feedback**: No floating damage numbers
3. **Visual Effects Not Synced**: Effects are client-side only
4. **No Mana Regeneration**: Mana doesn't restore over time
5. **No Health Loss**: Health bar doesn't decrease (no damage taken)

## Future Test Additions

When these features are added:
- Enemy NPC combat testing
- Damage calculation verification
- Health/mana regeneration
- Death and respawn
- Equipment and stat bonuses
- Level progression
- Skill point earning
