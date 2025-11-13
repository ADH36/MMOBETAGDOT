# Character System Documentation

## Overview
This document describes the new character system, main menu, and character creation features added to the MMO 2D Game.

## Features

### 1. Main Menu
- **Location**: `scenes/MainMenu.tscn`
- **Script**: `scripts/MainMenu.gd`
- **Features**:
  - New Game - Start character creation
  - Load Character - Load an existing saved character
  - Exit - Close the game

### 2. Character Creation
- **Location**: `scenes/CharacterCreation.tscn`
- **Script**: `scripts/CharacterCreation.gd`
- **Features**:
  - Character name input (max 20 characters)
  - Class selection (4 classes available)
  - Appearance customization:
    - Skin tone selection (4 options)
    - Hair color selection (6 options)
  - Live character preview
  - Class descriptions

#### Available Classes

##### Warrior
- **Health**: 150
- **Mana**: 30
- **Strength**: 15
- **Intelligence**: 5
- **Agility**: 8
- **Color**: Red
- **Description**: High health and strength. Excels in close combat.

##### Mage
- **Health**: 80
- **Mana**: 100
- **Strength**: 5
- **Intelligence**: 15
- **Agility**: 8
- **Color**: Blue
- **Description**: High mana and intelligence. Master of magic spells.

##### Rogue
- **Health**: 100
- **Mana**: 50
- **Strength**: 8
- **Intelligence**: 8
- **Agility**: 15
- **Color**: Dark Gray
- **Description**: High agility and speed. Expert in stealth and critical hits.

##### Archer
- **Health**: 110
- **Mana**: 40
- **Strength**: 10
- **Intelligence**: 8
- **Agility**: 12
- **Color**: Green
- **Description**: Balanced stats. Skilled in ranged combat.

### 3. Character Loading
- **Location**: `scenes/LoadCharacter.tscn`
- **Script**: `scripts/LoadCharacter.gd`
- **Features**:
  - Display up to 3 save slots
  - Show character info for saved characters
  - Load character to continue playing
  - Delete character option

### 4. Character Data System
- **Location**: `scripts/CharacterData.gd`
- **Type**: Resource class
- **Features**:
  - Store character information
  - Save to file system
  - Load from file system
  - Class-based stat application
  - Timestamp tracking

### 5. Enhanced 2D Character
- **Location**: Updated `scenes/Player.tscn` and `scripts/Player.gd`
- **Features**:
  - Multi-part sprite system:
    - Body (colored by skin tone)
    - Head (colored by skin tone)
    - Hair (colored by hair color)
    - Outfit (colored by class)
  - Dynamic appearance updates
  - Character data integration

## Game Flow

1. **Main Menu** → User selects "New Game" or "Load Character"
2. **Character Creation** (if New Game) → User creates character with customization
3. **Character Loading** (if Load) → User selects saved character
4. **Login Screen** → User enters server connection details
5. **Game World** → Player enters game with their customized character

## Save System

Characters are saved as Godot Resource files (.tres) in the user data directory:
- `user://character_slot_0.tres`
- `user://character_slot_1.tres`
- `user://character_slot_2.tres`

Each save contains:
- Character name
- Class
- Appearance settings (skin tone, hair color, colors)
- Stats
- Creation and last played timestamps

## Code Structure

### CharacterData.gd
Main data class that stores all character information and handles save/load operations.

### MainMenu.gd
Controls the main menu interface and navigates to character creation or loading.

### CharacterCreation.gd
Manages character creation process with live preview and validation.

### LoadCharacter.gd
Handles loading saved characters from file system.

### MainGame.gd (Updated)
Orchestrates flow between all menus and game world.

### Player.gd (Updated)
Updated to support visual customization based on CharacterData.

### GameWorld.gd (Updated)
Updated to spawn players with full character data.

## Usage

### Starting the Game
1. Launch the game - Main menu appears
2. Choose "New Game" for character creation or "Load Character" to continue

### Creating a Character
1. Enter a character name
2. Select a class from the dropdown
3. Adjust skin tone with the slider
4. Adjust hair color with the slider
5. Preview updates automatically
6. Click "Create Character" when satisfied

### Loading a Character
1. Select a save slot with an existing character
2. Character loads and you proceed to login
3. Optionally delete a character with the delete button

### Customization Options
- **4 Skin Tones**: Light, Medium, Dark, Darker
- **6 Hair Colors**: Black, Brown, Blonde, Red, White, Gray
- **4 Classes**: Each with unique stats and appearance

## Future Enhancements

Potential improvements for the character system:
- More classes (Paladin, Necromancer, etc.)
- More appearance options (facial features, accessories)
- Character level and experience system
- Equipment and inventory
- More save slots
- Character portraits
- Animated sprites
