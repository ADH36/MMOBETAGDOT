extends Control

@onready var new_game_button = $Panel/VBoxContainer/NewGameButton
@onready var load_game_button = $Panel/VBoxContainer/LoadGameButton
@onready var exit_button = $Panel/VBoxContainer/ExitButton
@onready var title_label = $Panel/VBoxContainer/TitleLabel

signal new_game_pressed
signal load_game_pressed

func _ready():
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# Check if there are any saved characters
	var has_saves = false
	for i in range(3):  # Check first 3 slots
		if CharacterData.slot_has_save(i):
			has_saves = true
			break
	
	# Disable load button if no saves exist
	load_game_button.disabled = not has_saves

func _on_new_game_pressed():
	emit_signal("new_game_pressed")

func _on_load_game_pressed():
	emit_signal("load_game_pressed")

func _on_exit_pressed():
	get_tree().quit()
