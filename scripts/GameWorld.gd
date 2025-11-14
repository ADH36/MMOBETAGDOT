extends Node2D

# World types
enum WorldType { JUNGLE, VILLAGE }

@onready var players_container = $Players
@onready var camera = $Camera2D
@onready var combat_ui = $CombatUI
@onready var skill_upgrade_ui = $SkillUpgradeUI
@onready var decorations_container = $Decorations
@onready var monsters_container = $Monsters
@onready var npcs_container = $NPCs
var player_scene = preload("res://scenes/Player.tscn")
var monster_scene = preload("res://scenes/Monster.tscn")
var npc_scene = preload("res://scenes/NPC.tscn")
var local_player = null
var network_players = {}
var current_world: WorldType = WorldType.JUNGLE
var decorations: Node2D = null

func _ready():
	# Connect to network manager signals
	NetworkManager.player_joined.connect(_on_player_joined)
	NetworkManager.player_left.connect(_on_player_left)
	NetworkManager.player_moved.connect(_on_player_moved)
	_setup_world(current_world)

func _process(_delta):
	# Make camera follow local player
	if local_player:
		camera.global_position = local_player.global_position

func _input(event):
	# Toggle world with 'M' key for testing
	if event.is_action_pressed("ui_focus_next"):  # Tab key
		if current_world == WorldType.JUNGLE:
			change_world(WorldType.VILLAGE)
		else:
			change_world(WorldType.JUNGLE)

func spawn_local_player(char_data: CharacterData):
	if local_player:
		return
	
	local_player = player_scene.instantiate()
	local_player.is_local_player = true
	local_player.set_player_name(char_data.character_name)
	local_player.update_appearance(char_data)
	local_player.global_position = Vector2(640, 360)  # Center of screen
	players_container.add_child(local_player)
	
	# Setup combat UI
	if combat_ui:
		combat_ui.set_character_data(char_data)
	
	# Setup skill upgrade UI
	if skill_upgrade_ui:
		skill_upgrade_ui.set_character_data(char_data)

func _on_player_joined(player_data: Dictionary):
	var player_id = player_data.get("id", "")
	if player_id.is_empty() or network_players.has(player_id):
		return
	
	var player = player_scene.instantiate()
	player.is_local_player = false
	player.set_player_name(player_data.get("username", "Player"))
	player.global_position = Vector2(
		player_data.get("x", 640),
		player_data.get("y", 360)
	)
	
	network_players[player_id] = player
	players_container.add_child(player)

func _on_player_left(player_id: String):
	if network_players.has(player_id):
		var player = network_players[player_id]
		player.queue_free()
		network_players.erase(player_id)

func _on_player_moved(player_id: String, position: Vector2):
	if network_players.has(player_id):
		var player = network_players[player_id]
		player.set_position_smooth(position)

func _setup_world(world_type: WorldType):
	"""Setup the world based on type"""
	# Clear old decorations
	if decorations:
		decorations.queue_free()
	
	# Clear old monsters and NPCs
	for child in monsters_container.get_children():
		child.queue_free()
	for child in npcs_container.get_children():
		child.queue_free()
	
	# Load decoration script and create instance
	var decoration_script = load("res://scripts/WorldDecoration.gd")
	decorations = Node2D.new()
	decorations.set_script(decoration_script)
	decorations_container.add_child(decorations)
	
	# Setup world appearance and decorations
	var world_bounds = Rect2(0, 0, 1280, 720)
	match world_type:
		WorldType.JUNGLE:
			$Background.color = Color(0.1, 0.3, 0.1)  # Dark green for jungle
			decorations.create_jungle_decorations(world_bounds)
			spawn_jungle_entities()
		WorldType.VILLAGE:
			$Background.color = Color(0.6, 0.5, 0.3)  # Brown/tan for village
			decorations.create_village_decorations(world_bounds)
			spawn_village_entities()

func change_world(world_type: WorldType):
	"""Change to a different world"""
	current_world = world_type
	_setup_world(world_type)

func spawn_jungle_entities():
	"""Spawn monsters and NPCs for jungle world"""
	# Spawn some slimes (basic monsters)
	for i in range(5):
		var monster = monster_scene.instantiate()
		monster.monster_name = "Jungle Slime"
		monster.monster_type = "basic"
		monster.max_health = 50
		monster.gold_drop_min = 2
		monster.gold_drop_max = 8
		monster.global_position = Vector2(
			randf_range(100, 1180),
			randf_range(100, 620)
		)
		monsters_container.add_child(monster)
	
	# Spawn an elite monster
	var elite = monster_scene.instantiate()
	elite.monster_name = "Forest Guardian"
	elite.monster_type = "elite"
	elite.max_health = 120
	elite.attack_damage = 10
	elite.gold_drop_min = 10
	elite.gold_drop_max = 20
	elite.global_position = Vector2(randf_range(300, 980), randf_range(200, 520))
	monsters_container.add_child(elite)
	
	# Spawn an NPC
	var npc = npc_scene.instantiate()
	npc.npc_name = "Jungle Explorer"
	npc.npc_type = "quest_giver"
	npc.dialogue_text = "These jungles are full of dangerous creatures! Be careful out there, adventurer."
	npc.global_position = Vector2(200, 200)
	npcs_container.add_child(npc)

func spawn_village_entities():
	"""Spawn monsters and NPCs for village world"""
	# Spawn some bandits (basic monsters)
	for i in range(3):
		var monster = monster_scene.instantiate()
		monster.monster_name = "Bandit"
		monster.monster_type = "basic"
		monster.max_health = 60
		monster.attack_damage = 7
		monster.gold_drop_min = 5
		monster.gold_drop_max = 12
		monster.global_position = Vector2(
			randf_range(100, 1180),
			randf_range(100, 620)
		)
		monsters_container.add_child(monster)
	
	# Spawn merchant NPC
	var merchant = npc_scene.instantiate()
	merchant.npc_name = "Village Merchant"
	merchant.npc_type = "merchant"
	merchant.dialogue_text = "Welcome to my shop! I have wares if you have coin."
	merchant.global_position = Vector2(300, 300)
	npcs_container.add_child(merchant)
	
	# Spawn generic NPC
	var villager = npc_scene.instantiate()
	villager.npc_name = "Friendly Villager"
	villager.npc_type = "generic"
	villager.dialogue_text = "Nice weather we're having today!"
	villager.global_position = Vector2(600, 400)
	npcs_container.add_child(villager)
