extends Control

@onready var slot_container = $Panel/VBoxContainer/SlotContainer
@onready var back_button = $Panel/VBoxContainer/BackButton
@onready var delete_button = $Panel/VBoxContainer/DeleteButton

signal character_loaded(character_data)
signal back_pressed

var selected_slot: int = -1
var slot_buttons = []

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	delete_button.pressed.connect(_on_delete_pressed)
	delete_button.disabled = true
	
	_setup_slot_buttons()

func _setup_slot_buttons():
	# Clear existing buttons
	for child in slot_container.get_children():
		child.queue_free()
	slot_buttons.clear()
	
	# Create buttons for each save slot
	for i in range(3):  # 3 save slots
		var button = Button.new()
		button.custom_minimum_size = Vector2(400, 60)
		
		if CharacterData.slot_has_save(i):
			var char_data = CharacterData.load_from_file(i)
			if char_data:
				button.text = "%s - %s (Level 1)\nLast Played: %s" % [
					char_data.character_name,
					char_data.character_class,
					char_data.last_played
				]
		else:
			button.text = "Slot %d - Empty" % (i + 1)
			button.disabled = true
		
		button.pressed.connect(_on_slot_selected.bind(i))
		slot_container.add_child(button)
		slot_buttons.append(button)

func _on_slot_selected(slot: int):
	selected_slot = slot
	delete_button.disabled = false
	
	var char_data = CharacterData.load_from_file(slot)
	if char_data:
		emit_signal("character_loaded", char_data)

func _on_back_pressed():
	emit_signal("back_pressed")

func _on_delete_pressed():
	if selected_slot >= 0:
		var save_path = "user://character_slot_%d.tres" % selected_slot
		DirAccess.remove_absolute(save_path)
		selected_slot = -1
		delete_button.disabled = true
		_setup_slot_buttons()
