extends Node

@onready var login_ui = $LoginUI
@onready var game_world = $GameWorld
@onready var ui_layer = $UILayer

var network_manager = null

func _ready():
	# Add NetworkManager as autoload singleton
	if not has_node("/root/NetworkManager"):
		network_manager = load("res://scripts/NetworkManager.gd").new()
		network_manager.name = "NetworkManager"
		get_tree().root.add_child(network_manager)
	
	# Hide game world initially
	game_world.visible = false
	ui_layer.visible = false
	
	# Connect login signal
	login_ui.login_successful.connect(_on_login_successful)

func _on_login_successful(username: String):
	print("Login successful for: ", username)
	
	# Show game world
	game_world.visible = true
	ui_layer.visible = true
	
	# Spawn local player
	game_world.spawn_local_player(username)
