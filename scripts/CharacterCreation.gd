extends Control

@onready var character_name_input = $Panel/VBoxContainer/NameInput
@onready var class_option_button = $Panel/VBoxContainer/ClassContainer/ClassOptionButton
@onready var skin_tone_slider = $Panel/VBoxContainer/SkinToneContainer/SkinToneSlider
@onready var hair_color_slider = $Panel/VBoxContainer/HairColorContainer/HairColorSlider
@onready var create_button = $Panel/VBoxContainer/CreateButton
@onready var back_button = $Panel/VBoxContainer/BackButton
@onready var preview_character = $Panel/CharacterPreview/PreviewPlayer
@onready var class_description = $Panel/VBoxContainer/ClassContainer/ClassDescription

signal character_created(character_data)
signal back_pressed

var character_data: CharacterData

# Color presets
var skin_tones = [
	Color(1.0, 0.87, 0.74),  # Light
	Color(0.8, 0.6, 0.4),    # Medium
	Color(0.6, 0.4, 0.2),    # Dark
	Color(0.4, 0.3, 0.2)     # Darker
]

var hair_colors = [
	Color(0.1, 0.1, 0.1),    # Black
	Color(0.4, 0.2, 0.1),    # Brown
	Color(0.8, 0.6, 0.2),    # Blonde
	Color(0.8, 0.3, 0.1),    # Red
	Color(0.9, 0.9, 0.9),    # White
	Color(0.5, 0.5, 0.5)     # Gray
]

var class_descriptions = {
	"Warrior": "High health and strength. Excels in close combat.",
	"Mage": "High mana and intelligence. Master of magic spells.",
	"Rogue": "High agility and speed. Expert in stealth and critical hits.",
	"Archer": "Balanced stats. Skilled in ranged combat."
}

func _ready():
	character_data = CharacterData.new()
	
	# Setup class options
	class_option_button.clear()
	class_option_button.add_item("Warrior")
	class_option_button.add_item("Mage")
	class_option_button.add_item("Rogue")
	class_option_button.add_item("Archer")
	
	# Setup sliders
	skin_tone_slider.min_value = 0
	skin_tone_slider.max_value = skin_tones.size() - 1
	skin_tone_slider.step = 1
	skin_tone_slider.value = 0
	
	hair_color_slider.min_value = 0
	hair_color_slider.max_value = hair_colors.size() - 1
	hair_color_slider.step = 1
	hair_color_slider.value = 0
	
	# Connect signals
	create_button.pressed.connect(_on_create_pressed)
	back_button.pressed.connect(_on_back_pressed)
	class_option_button.item_selected.connect(_on_class_selected)
	skin_tone_slider.value_changed.connect(_on_skin_tone_changed)
	hair_color_slider.value_changed.connect(_on_hair_color_changed)
	character_name_input.text_changed.connect(_on_name_changed)
	
	# Initial update
	_update_preview()
	_update_class_description()

func _on_create_pressed():
	var char_name = character_name_input.text.strip_edges()
	
	if char_name.is_empty():
		# Show error - name required
		return
	
	character_data.character_name = char_name
	character_data.apply_class_stats()
	
	# Save character to slot 0 (can be extended to multiple slots)
	character_data.save_to_file(0)
	
	emit_signal("character_created", character_data)

func _on_back_pressed():
	emit_signal("back_pressed")

func _on_class_selected(index: int):
	var selected_class = class_option_button.get_item_text(index)
	character_data.character_class = selected_class
	_update_preview()
	_update_class_description()

func _on_skin_tone_changed(value: float):
	character_data.skin_tone = int(value)
	character_data.body_color = skin_tones[int(value)]
	_update_preview()

func _on_hair_color_changed(value: float):
	character_data.hair_color = int(value)
	character_data.hair_color_value = hair_colors[int(value)]
	_update_preview()

func _on_name_changed(new_text: String):
	# Enable/disable create button based on name
	create_button.disabled = new_text.strip_edges().is_empty()

func _update_preview():
	if preview_character:
		preview_character.update_appearance(character_data)

func _update_class_description():
	if class_description:
		class_description.text = class_descriptions.get(character_data.character_class, "")
