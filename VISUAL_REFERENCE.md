# Visual Reference Guide

This document describes the visual appearance of the combat and world systems.

## Game World Visuals

### Jungle World
**Background**: Dark green (#1A4D1A approximately)

**Decorations**:
- **Trees**: 
  - Trunk: Brown rectangle (10x30 pixels)
  - Leaves: Green square (30x30 pixels) above trunk
  - Total: ~15 trees randomly placed
  
- **Bushes**:
  - Dark green rectangles (20x15 pixels)
  - Total: ~20 bushes randomly placed

### Village World
**Background**: Brown/tan (#998066 approximately)

**Decorations**:
- **Houses**:
  - Walls: Tan/brown rectangle (60x50 pixels)
  - Roof: Dark brown rectangle (70x20 pixels) on top
  - Door: Brown rectangle (15x25 pixels) at bottom center
  - Total: ~5 houses randomly placed
  
- **Fences**:
  - Brown rectangles (40x15 pixels)
  - Total: ~10 fences randomly placed

## Player Character Visuals

**Player Structure** (from top to bottom):
1. **Hair**: Colored rectangle (20x10 pixels) - varies by customization
2. **Head**: Skin-colored rectangle (20x20 pixels)
3. **Body**: Skin-colored rectangle (24x20 pixels)
4. **Outfit**: Class-colored rectangle (28x12 pixels)
   - Warrior: Red (#CC3333)
   - Mage: Blue (#4D4DE6)
   - Rogue: Dark gray (#4D4D4D)
   - Archer: Green (#33B34D)
5. **Name Label**: White text above character

## Combat UI Layout

### Top-Left Panel (310x100 pixels)
```
┌─────────────────────────────────┐
│ Health Bar                       │
│ [████████████████░░] 150/150    │
│                                  │
│ Mana Bar                         │
│ [██████████░░░░░░░░] 100/100    │
└─────────────────────────────────┘
```

### Bottom Skill Bar (400x60 pixels)
```
┌──────────┬──────────┐
│ Skill 1  │ Skill 2  │
│ Ready    │ 2.5s     │
│   [1]    │   [2]    │
└──────────┴──────────┘
```

## Visual Effects

### Attack Effect
- **Color**: Yellow/orange (#FFCC33)
- **Size**: 25x25 pixels
- **Position**: ~30 pixels in front of player
- **Animation**: 
  - Fades from alpha 1.0 to 0.0 over 0.5 seconds
  - Scales from 1.0 to 1.5 over 0.5 seconds
- **Lifetime**: 0.5 seconds

### Skill Effects (Class-Specific)

**Warrior**:
- Power Slash: Red (#E63333), 40x40 pixels
- Charge: Orange (#FF9933), 50x50 pixels

**Mage**:
- Fireball: Orange (#FF4D00), 35x35 pixels
- Ice Shard: Blue (#4D99FF), 32x32 pixels

**Rogue**:
- Backstab: Gray (#808080), 30x30 pixels
- Poison Dart: Green (#66CC33), 25x25 pixels

**Archer**:
- Multi-Shot: Brown (#996633), 30x30 pixels
- Explosive Arrow: Orange (#FF9933), 45x45 pixels

## Skill Upgrade UI

**Panel**: Centered on screen (500x500 pixels)

**Layout**:
```
┌─────────────────────────────────────┐
│         Skill Upgrades               │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Power Slash                     │ │
│ │ Level: 1 / 5                    │ │
│ │ Damage: 30 | Mana: 10 | CD: 3s │ │
│ │ [Upgrade (Level 1 → 2)]         │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Charge                          │ │
│ │ Level: 1 / 5                    │ │
│ │ Damage: 25 | Mana: 15 | CD: 5s │ │
│ │ [Upgrade (Level 1 → 2)]         │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [Close (PageUp)]                    │
└─────────────────────────────────────┘
```

## Color Codes Reference

### World Colors
- Jungle Background: `Color(0.1, 0.3, 0.1)` - Dark green
- Village Background: `Color(0.6, 0.5, 0.3)` - Brown/tan
- Tree Trunk: `Color(0.4, 0.2, 0.1)` - Brown
- Tree Leaves: `Color(0.1, 0.5, 0.1)` - Green
- Bush: `Color(0.15, 0.4, 0.15)` - Dark green
- House Walls: `Color(0.7, 0.5, 0.3)` - Tan
- House Roof: `Color(0.5, 0.2, 0.1)` - Dark brown
- Fence: `Color(0.5, 0.3, 0.2)` - Brown

### Class Colors
- Warrior Outfit: `Color(0.8, 0.2, 0.2)` - Red
- Mage Outfit: `Color(0.3, 0.3, 0.9)` - Blue
- Rogue Outfit: `Color(0.3, 0.3, 0.3)` - Dark gray
- Archer Outfit: `Color(0.2, 0.7, 0.3)` - Green

### Effect Colors
- Basic Attack: `Color(1, 0.8, 0.2)` - Yellow/orange
- Power Slash: `Color(0.9, 0.2, 0.2)` - Red
- Charge: `Color(1, 0.5, 0)` - Orange
- Fireball: `Color(1, 0.3, 0)` - Orange
- Ice Shard: `Color(0.3, 0.6, 1)` - Blue
- Backstab: `Color(0.5, 0.5, 0.5)` - Gray
- Poison Dart: `Color(0.4, 0.8, 0.2)` - Green
- Multi-Shot: `Color(0.6, 0.4, 0.2)` - Brown
- Explosive Arrow: `Color(1, 0.6, 0)` - Orange

## UI Text

### Health/Mana Labels
- Format: `"XXX / XXX"` (current / max)
- Font: Default Godot font
- Color: White
- Position: Centered on bar

### Skill Hotbar
- Skill Name: Top of panel
- Cooldown/Ready: Middle of panel
- Key Binding: Bottom of panel (e.g., "[1]")
- Font Size: 
  - Name: 10px
  - Cooldown: Default
  - Key: 12px

### Skill Upgrade UI
- Title: 20px, centered
- Skill Name: 16px
- Stats: Default size
- Buttons: Standard Godot button style

## Camera Behavior

- **Follow Speed**: Instant (position = player position)
- **Update Rate**: Every frame
- **Zoom**: 1.0 (no zoom)
- **Rotation**: 0 (no rotation)
- **Smoothing**: None (direct follow)

## Animation Details

### Effect Fade
- Start Alpha: 1.0 (fully visible)
- End Alpha: 0.0 (invisible)
- Duration: 0.5 seconds
- Curve: Linear

### Effect Scale
- Start Scale: (1.0, 1.0)
- End Scale: (1.5, 1.5)
- Duration: 0.5 seconds
- Curve: Linear

### Skill Cooldown
- Updates: Every frame (delta time)
- Display: 1 decimal place (e.g., "2.5")
- Format: Seconds (e.g., "3.0s" → "2.9" → "2.8" → ... → "Ready")

## Screen Layout

```
┌──────────────────────────────────────────┐
│ Health/Mana Panel                        │ Top-left
│ (310x100)                                │
│                                          │
│                                          │
│                                          │
│           Game World                     │
│       (Camera follows player)            │
│                                          │
│                                          │
│                                          │
│                                          │
│                                          │
│ Skill Bar (400x60)                       │ Bottom-left
└──────────────────────────────────────────┘

Skill Upgrade UI: Centered overlay (when open)
```

## Positioning Reference

### World Bounds
- Width: 1280 pixels
- Height: 720 pixels
- Origin: (0, 0) at top-left

### Player Spawn
- Default: (640, 360) - center of screen
- Network players: Server-provided position

### Effect Spawn
- Attack: Player position + (30, 0) - 30 pixels to the right
- Skills: Player position + (40, 0) - 40 pixels to the right

### Decoration Spread
- Jungle: Full screen (0-1280, 0-720)
- Village: Full screen (0-1280, 0-720)
- Random placement using RNG

## Expected Visual Flow

1. **Game Start**: Jungle world loads
   - Green background appears
   - Trees and bushes spawn
   - Player spawns at center
   - Camera centers on player

2. **Movement**: Player moves with WASD
   - Camera follows smoothly
   - Player sprite moves
   - Decorations stay in place

3. **Attack**: Press Space
   - Yellow flash appears briefly
   - Effect fades and scales
   - Effect disappears after 0.5s

4. **Skill Cast**: Press 1 or 2
   - Colored effect appears
   - Mana bar decreases
   - Cooldown timer starts
   - Effect fades and scales

5. **World Switch**: Press Tab
   - Background color changes
   - Old decorations vanish
   - New decorations appear
   - Player stays in place

6. **UI Interaction**: Press PageUp
   - Skill panel appears centered
   - Game world visible behind
   - Click to upgrade skills
   - Press PageUp to close

This visual reference ensures consistent appearance across all features.
