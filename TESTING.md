# Testing Guide for Character System

This document provides a comprehensive testing guide for the new character creation and customization features.

## Prerequisites

1. Godot Engine 4.5.1 installed
2. Project opened in Godot
3. Node.js server running (for multiplayer testing)

## Test Cases

### 1. Main Menu Testing

**Test 1.1: Main Menu Display**
- [ ] Launch the game
- [ ] Verify Main Menu appears with three buttons:
  - "New Game"
  - "Load Character" (may be disabled if no saves exist)
  - "Exit"
- [ ] Verify title "MMO 2D Game" is displayed
- [ ] Verify dark blue background is shown

**Test 1.2: Exit Button**
- [ ] Click "Exit" button
- [ ] Verify game closes properly

**Test 1.3: Load Button State**
- [ ] Launch game for first time (no saves)
- [ ] Verify "Load Character" button is disabled
- [ ] Create and save a character (see Test 2.x)
- [ ] Relaunch game
- [ ] Verify "Load Character" button is now enabled

### 2. Character Creation Testing

**Test 2.1: Navigation to Character Creation**
- [ ] Click "New Game" on Main Menu
- [ ] Verify Character Creation screen appears
- [ ] Verify all UI elements are present:
  - Title "Create Your Character"
  - Name input field
  - Class dropdown
  - Skin tone slider
  - Hair color slider
  - Character preview
  - "Create Character" button (disabled initially)
  - "Back" button

**Test 2.2: Character Name Input**
- [ ] Try to create character without entering name
- [ ] Verify "Create Character" button is disabled
- [ ] Enter a name (e.g., "TestHero")
- [ ] Verify "Create Character" button becomes enabled
- [ ] Verify name is limited to 20 characters

**Test 2.3: Class Selection**
- [ ] Click class dropdown
- [ ] Verify all 4 classes are available:
  - Warrior
  - Mage
  - Rogue
  - Archer
- [ ] Select "Warrior"
- [ ] Verify class description updates to show Warrior info
- [ ] Verify character preview outfit color changes to red
- [ ] Repeat for each class and verify:
  - Warrior: Red outfit
  - Mage: Blue outfit
  - Rogue: Dark gray outfit
  - Archer: Green outfit

**Test 2.4: Skin Tone Customization**
- [ ] Move skin tone slider to each position (0-3)
- [ ] Verify character preview body and head colors update
- [ ] Verify smooth color transitions:
  - Position 0: Light skin
  - Position 1: Medium skin
  - Position 2: Dark skin
  - Position 3: Darker skin

**Test 2.5: Hair Color Customization**
- [ ] Move hair color slider to each position (0-5)
- [ ] Verify character preview hair color updates
- [ ] Verify all 6 colors:
  - Position 0: Black
  - Position 1: Brown
  - Position 2: Blonde
  - Position 3: Red
  - Position 4: White
  - Position 5: Gray

**Test 2.6: Live Preview**
- [ ] Make multiple customization changes
- [ ] Verify preview updates immediately after each change
- [ ] Verify preview shows all 4 parts: hair, head, body, outfit

**Test 2.7: Create Character**
- [ ] Enter name "TestWarrior"
- [ ] Select "Warrior" class
- [ ] Choose skin tone and hair color
- [ ] Click "Create Character"
- [ ] Verify navigation to Login screen
- [ ] Verify character data is saved

**Test 2.8: Back Button**
- [ ] From Character Creation screen
- [ ] Click "Back" button
- [ ] Verify return to Main Menu
- [ ] Verify no character was saved

### 3. Load Character Testing

**Test 3.1: Navigation to Load Character**
- [ ] Create at least one saved character first
- [ ] Return to Main Menu
- [ ] Click "Load Character"
- [ ] Verify Load Character screen appears

**Test 3.2: Save Slot Display**
- [ ] Verify 3 save slots are shown
- [ ] For saved characters, verify display shows:
  - Character name
  - Character class
  - Last played timestamp
- [ ] For empty slots, verify:
  - "Slot X - Empty" is shown
  - Slot button is disabled

**Test 3.3: Load Character**
- [ ] Click on a slot with saved character
- [ ] Verify navigation to Login screen
- [ ] Verify correct character data is loaded

**Test 3.4: Delete Character**
- [ ] Select a saved character slot
- [ ] Verify "Delete Character" button becomes enabled
- [ ] Click "Delete Character"
- [ ] Verify character is removed from slot
- [ ] Verify slot now shows as empty

**Test 3.5: Back Button**
- [ ] From Load Character screen
- [ ] Click "Back to Main Menu"
- [ ] Verify return to Main Menu

### 4. Character Appearance Testing

**Test 4.1: Player Visual Structure**
- [ ] Create character with specific customization
- [ ] Proceed to game world
- [ ] Verify player character displays 4 colored parts:
  - Hair (top)
  - Head (middle-top)
  - Body (middle)
  - Outfit (bottom)

**Test 4.2: Appearance Persistence**
- [ ] Create character with specific appearance
- [ ] Note the customization choices
- [ ] Exit game completely
- [ ] Relaunch game
- [ ] Load the saved character
- [ ] Proceed to game world
- [ ] Verify appearance matches original customization

**Test 4.3: Different Classes**
- [ ] Create 4 different characters (one of each class)
- [ ] For each character, verify in game world:
  - Warrior: Red outfit
  - Mage: Blue outfit
  - Rogue: Dark gray outfit
  - Archer: Green outfit

### 5. Save System Testing

**Test 5.1: Single Save**
- [ ] Create and save one character
- [ ] Check user data directory (location varies by OS)
- [ ] Verify file exists: `character_slot_0.tres`

**Test 5.2: Multiple Saves**
- [ ] Create and save first character
- [ ] Return to menu, create second character
- [ ] Note: Currently only slot 0 is used (limitation)
- [ ] Verify new character overwrites slot 0

**Test 5.3: Save Data Integrity**
- [ ] Create character with:
  - Name: "DataTest"
  - Class: Mage
  - Skin tone: 2
  - Hair color: 4
- [ ] Save character
- [ ] Reload character
- [ ] Verify all data matches:
  - Name is "DataTest"
  - Class is Mage
  - Skin tone is correct (dark)
  - Hair color is correct (white)
  - Stats match Mage stats

### 6. Integration Testing

**Test 6.1: Complete Flow (New Character)**
- [ ] Start game
- [ ] Main Menu → New Game
- [ ] Create character with custom appearance
- [ ] Proceed to Login
- [ ] Enter username and connect
- [ ] Verify entry to game world
- [ ] Verify character appears with correct customization

**Test 6.2: Complete Flow (Load Character)**
- [ ] Start game (with existing save)
- [ ] Main Menu → Load Character
- [ ] Select saved character
- [ ] Proceed to Login
- [ ] Enter username and connect
- [ ] Verify entry to game world
- [ ] Verify character appears with saved customization

**Test 6.3: Movement with Custom Character**
- [ ] Load character into game world
- [ ] Use WASD/Arrow keys to move
- [ ] Verify character moves properly
- [ ] Verify appearance is maintained during movement
- [ ] Verify name label displays correctly above character

### 7. Multiplayer Testing

**Test 7.1: Multiple Custom Characters**
- [ ] Start server
- [ ] Launch first client
- [ ] Create/load character with Warrior class
- [ ] Connect to server
- [ ] Launch second client
- [ ] Create/load character with Mage class
- [ ] Connect to server
- [ ] On each client:
  - [ ] Verify local character has correct appearance
  - [ ] Verify other player is visible
  - [ ] Note: Remote player appearance may not sync (requires server support)

**Test 7.2: Name Display**
- [ ] Connect multiple clients with different character names
- [ ] Verify each character displays their correct name label
- [ ] Verify name labels are visible for remote players

### 8. Error Handling Testing

**Test 8.1: Empty Name**
- [ ] Try to create character without entering name
- [ ] Verify "Create Character" button is disabled
- [ ] Verify no error messages appear

**Test 8.2: Special Characters in Name**
- [ ] Enter special characters in name field
- [ ] Verify characters are accepted (or properly handled)
- [ ] Verify character can be created and saved

**Test 8.3: Corrupted Save**
- [ ] Manually corrupt a save file in user directory
- [ ] Try to load the corrupted save
- [ ] Verify game handles gracefully (shows as empty slot or error)

### 9. UI/UX Testing

**Test 9.1: Responsive Preview**
- [ ] Make rapid changes to sliders
- [ ] Verify preview updates smoothly
- [ ] Verify no visual glitches

**Test 9.2: Button States**
- [ ] Verify all buttons have correct enabled/disabled states
- [ ] Verify visual feedback when hovering over buttons
- [ ] Verify buttons respond to clicks

**Test 9.3: Navigation Flow**
- [ ] Test all navigation paths:
  - Menu → Create → Back → Menu
  - Menu → Create → Login → Game
  - Menu → Load → Back → Menu
  - Menu → Load → Login → Game
- [ ] Verify smooth transitions between screens

## Known Limitations

1. **Save Slot System**: Currently, character creation always uses slot 0. Multiple save slots are displayed but all saves go to slot 0.
2. **Network Appearance Sync**: Character appearance is not synchronized over the network. Remote players appear with default appearance.
3. **Animation**: Characters don't have animations, they use static ColorRect parts.
4. **Equipment**: No equipment or inventory system yet.

## Success Criteria

All test cases should pass with no critical bugs. Minor UI improvements may be noted for future enhancement.

## Bug Reporting

When reporting bugs, include:
- Test case number
- Steps to reproduce
- Expected result
- Actual result
- Screenshots if applicable
- Godot version
- Operating system
