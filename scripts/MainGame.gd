extends Node

# Scene references
var main_menu_scene = preload("res://scenes/MainMenu.tscn")
var character_creation_scene = preload("res://scenes/CharacterCreation.tscn")
var load_character_scene = preload("res://scenes/LoadCharacter.tscn")

@onready var login_ui = $LoginUI
@onready var game_world = $GameWorld
@onready var ui_layer = $UILayer

# Current UI nodes
var current_ui = null
var current_character_data: CharacterData = null

func _ready():
	# Hide game world and login initially
	game_world.visible = false
	ui_layer.visible = false
	login_ui.visible = false
	
	# Show main menu
	_show_main_menu()

func _show_main_menu():
	_clear_current_ui()
	
	current_ui = main_menu_scene.instantiate()
	add_child(current_ui)
	
	current_ui.new_game_pressed.connect(_on_new_game_pressed)
	current_ui.load_game_pressed.connect(_on_load_game_pressed)

func _show_character_creation():
	_clear_current_ui()
	
	current_ui = character_creation_scene.instantiate()
	add_child(current_ui)
	
	current_ui.character_created.connect(_on_character_created)
	current_ui.back_pressed.connect(_on_back_to_main_menu)

func _show_load_character():
	_clear_current_ui()
	
	current_ui = load_character_scene.instantiate()
	add_child(current_ui)
	
	current_ui.character_loaded.connect(_on_character_loaded)
	current_ui.back_pressed.connect(_on_back_to_main_menu)

func _show_login(char_data: CharacterData):
	_clear_current_ui()
	
	current_character_data = char_data
	login_ui.visible = true
	
	# Connect login signal if not already connected
	if not login_ui.login_successful.is_connected(_on_login_successful):
		login_ui.login_successful.connect(_on_login_successful)

func _clear_current_ui():
	if current_ui:
		current_ui.queue_free()
		current_ui = null

func _on_new_game_pressed():
	_show_character_creation()

func _on_load_game_pressed():
	_show_load_character()

func _on_back_to_main_menu():
	_show_main_menu()

func _on_character_created(char_data: CharacterData):
	print("Character created: ", char_data.character_name)
	_show_login(char_data)

func _on_character_loaded(char_data: CharacterData):
	print("Character loaded: ", char_data.character_name)
	_show_login(char_data)

func _on_login_successful(username: String):
	print("Login successful for: ", username)
	
	# Hide login UI
	login_ui.visible = false
	
	# Show game world
	game_world.visible = true
	ui_layer.visible = true
	
	# Spawn local player with character data
	if current_character_data:
		game_world.spawn_local_player(current_character_data)
	else:
		# Fallback to default character
		var default_char = CharacterData.new()
		default_char.character_name = username
		default_char.apply_class_stats()
		game_world.spawn_local_player(default_char)
