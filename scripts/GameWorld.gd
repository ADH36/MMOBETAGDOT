extends Node2D

@onready var players_container = $Players
var player_scene = preload("res://scenes/Player.tscn")
var local_player = null
var network_players = {}

func _ready():
	# Connect to network manager signals
	NetworkManager.player_joined.connect(_on_player_joined)
	NetworkManager.player_left.connect(_on_player_left)
	NetworkManager.player_moved.connect(_on_player_moved)

func spawn_local_player(char_data: CharacterData):
	if local_player:
		return
	
	local_player = player_scene.instantiate()
	local_player.is_local_player = true
	local_player.set_player_name(char_data.character_name)
	local_player.update_appearance(char_data)
	local_player.global_position = Vector2(640, 360)  # Center of screen
	players_container.add_child(local_player)

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
