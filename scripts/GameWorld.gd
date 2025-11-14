extends Node2D

# World types
enum WorldType { JUNGLE, VILLAGE }

@onready var players_container = $Players
@onready var camera = $Camera2D
@onready var combat_ui = $CombatUI
@onready var skill_upgrade_ui = $SkillUpgradeUI
@onready var decorations_container = $Decorations
var player_scene = preload("res://scenes/Player.tscn")
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
		WorldType.VILLAGE:
			$Background.color = Color(0.6, 0.5, 0.3)  # Brown/tan for village
			decorations.create_village_decorations(world_bounds)

func change_world(world_type: WorldType):
	"""Change to a different world"""
	current_world = world_type
	_setup_world(world_type)
