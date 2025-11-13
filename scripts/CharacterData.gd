extends Resource
class_name CharacterData

# Character basic info
@export var character_name: String = ""
@export var character_class: String = "Warrior"  # Warrior, Mage, Rogue, Archer

# Appearance customization
@export var skin_tone: int = 0  # 0-3 for different skin tones
@export var hair_color: int = 0  # 0-5 for different hair colors
@export var body_color: Color = Color(0.8, 0.6, 0.4)  # Skin color
@export var hair_color_value: Color = Color(0.4, 0.2, 0.1)  # Hair color
@export var outfit_color: Color = Color(0.2, 0.4, 0.8)  # Outfit/class color

# Game stats (class-based)
@export var max_health: int = 100
@export var max_mana: int = 50
@export var strength: int = 10
@export var intelligence: int = 10
@export var agility: int = 10

# Save timestamp
@export var created_at: String = ""
@export var last_played: String = ""

func _init():
	created_at = Time.get_datetime_string_from_system()
	last_played = created_at

func apply_class_stats():
	"""Apply stat modifiers based on character class"""
	match character_class:
		"Warrior":
			max_health = 150
			max_mana = 30
			strength = 15
			intelligence = 5
			agility = 8
			outfit_color = Color(0.8, 0.2, 0.2)  # Red
		"Mage":
			max_health = 80
			max_mana = 100
			strength = 5
			intelligence = 15
			agility = 8
			outfit_color = Color(0.3, 0.3, 0.9)  # Blue
		"Rogue":
			max_health = 100
			max_mana = 50
			strength = 8
			intelligence = 8
			agility = 15
			outfit_color = Color(0.3, 0.3, 0.3)  # Dark gray
		"Archer":
			max_health = 110
			max_mana = 40
			strength = 10
			intelligence = 8
			agility = 12
			outfit_color = Color(0.2, 0.7, 0.3)  # Green

func save_to_file(slot: int = 0):
	"""Save character data to file"""
	last_played = Time.get_datetime_string_from_system()
	var save_path = "user://character_slot_%d.tres" % slot
	var error = ResourceSaver.save(self, save_path)
	if error == OK:
		print("Character saved successfully to slot ", slot)
		return true
	else:
		print("Failed to save character: ", error)
		return false

static func load_from_file(slot: int = 0) -> CharacterData:
	"""Load character data from file"""
	var save_path = "user://character_slot_%d.tres" % slot
	if ResourceLoader.exists(save_path):
		var char_data = ResourceLoader.load(save_path)
		if char_data is CharacterData:
			print("Character loaded successfully from slot ", slot)
			return char_data
	print("No saved character found in slot ", slot)
	return null

static func slot_has_save(slot: int = 0) -> bool:
	"""Check if a save exists in the given slot"""
	var save_path = "user://character_slot_%d.tres" % slot
	return ResourceLoader.exists(save_path)
