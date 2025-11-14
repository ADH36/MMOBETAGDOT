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

# Combat stats (runtime)
var current_health: int = 100
var current_mana: int = 50
var base_attack_damage: int = 10
var attack_cooldown: float = 1.0
var current_attack_cooldown: float = 0.0

# Skills
@export var skills: Array[Skill] = []

# Save timestamp
@export var created_at: String = ""
@export var last_played: String = ""

func _init():
	created_at = Time.get_datetime_string_from_system()
	last_played = created_at
	_initialize_skills()

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
			base_attack_damage = 15
			_setup_warrior_skills()
		"Mage":
			max_health = 80
			max_mana = 100
			strength = 5
			intelligence = 15
			agility = 8
			outfit_color = Color(0.3, 0.3, 0.9)  # Blue
			base_attack_damage = 5
			_setup_mage_skills()
		"Rogue":
			max_health = 100
			max_mana = 50
			strength = 8
			intelligence = 8
			agility = 15
			outfit_color = Color(0.3, 0.3, 0.3)  # Dark gray
			base_attack_damage = 12
			_setup_rogue_skills()
		"Archer":
			max_health = 110
			max_mana = 40
			strength = 10
			intelligence = 8
			agility = 12
			outfit_color = Color(0.2, 0.7, 0.3)  # Green
			base_attack_damage = 10
			_setup_archer_skills()
	
	# Initialize current stats
	current_health = max_health
	current_mana = max_mana

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

func _initialize_skills():
	"""Initialize default skills based on class"""
	skills.clear()
	# Will be set properly in apply_class_stats
	
func get_attack_damage() -> int:
	"""Calculate total attack damage"""
	return base_attack_damage + strength

func is_attack_ready() -> bool:
	"""Check if attack is off cooldown"""
	return current_attack_cooldown <= 0.0

func start_attack_cooldown():
	"""Start attack cooldown"""
	current_attack_cooldown = attack_cooldown

func update_attack_cooldown(delta: float):
	"""Update attack cooldown"""
	if current_attack_cooldown > 0:
		current_attack_cooldown -= delta
		
func update_skills_cooldown(delta: float):
	"""Update all skills cooldowns"""
	for skill in skills:
		skill.update_cooldown(delta)

func can_cast_skill(skill_index: int) -> bool:
	"""Check if a skill can be cast"""
	if skill_index < 0 or skill_index >= skills.size():
		return false
	var skill = skills[skill_index]
	return skill.is_ready() and current_mana >= skill.get_mana_cost()

func cast_skill(skill_index: int) -> bool:
	"""Cast a skill if possible"""
	if not can_cast_skill(skill_index):
		return false
	var skill = skills[skill_index]
	current_mana -= skill.get_mana_cost()
	skill.start_cooldown()
	return true

func _setup_warrior_skills():
	"""Setup Warrior class skills"""
	skills.clear()
	
	var slash = Skill.new()
	slash.skill_name = "Power Slash"
	slash.skill_description = "A powerful melee attack"
	slash.base_damage = 30
	slash.mana_cost = 10
	slash.cooldown = 3.0
	slash.effect_color = Color(0.9, 0.2, 0.2)
	slash.effect_size = 40.0
	skills.append(slash)
	
	var charge = Skill.new()
	charge.skill_name = "Charge"
	charge.skill_description = "Rush forward damaging enemies"
	charge.base_damage = 25
	charge.mana_cost = 15
	charge.cooldown = 5.0
	charge.effect_color = Color(1, 0.5, 0)
	charge.effect_size = 50.0
	skills.append(charge)

func _setup_mage_skills():
	"""Setup Mage class skills"""
	skills.clear()
	
	var fireball = Skill.new()
	fireball.skill_name = "Fireball"
	fireball.skill_description = "Launch a ball of fire"
	fireball.base_damage = 40
	fireball.mana_cost = 20
	fireball.cooldown = 2.5
	fireball.effect_color = Color(1, 0.3, 0)
	fireball.effect_size = 35.0
	skills.append(fireball)
	
	var ice_shard = Skill.new()
	ice_shard.skill_name = "Ice Shard"
	ice_shard.skill_description = "Freeze enemies with ice"
	ice_shard.base_damage = 35
	ice_shard.mana_cost = 18
	ice_shard.cooldown = 3.0
	ice_shard.effect_color = Color(0.3, 0.6, 1)
	ice_shard.effect_size = 32.0
	skills.append(ice_shard)

func _setup_rogue_skills():
	"""Setup Rogue class skills"""
	skills.clear()
	
	var backstab = Skill.new()
	backstab.skill_name = "Backstab"
	backstab.skill_description = "Critical strike from behind"
	backstab.base_damage = 45
	backstab.mana_cost = 12
	backstab.cooldown = 4.0
	backstab.effect_color = Color(0.5, 0.5, 0.5)
	backstab.effect_size = 30.0
	skills.append(backstab)
	
	var poison = Skill.new()
	poison.skill_name = "Poison Dart"
	poison.skill_description = "Throw a poisoned dart"
	poison.base_damage = 20
	poison.mana_cost = 10
	poison.cooldown = 2.0
	poison.effect_color = Color(0.4, 0.8, 0.2)
	poison.effect_size = 25.0
	skills.append(poison)

func _setup_archer_skills():
	"""Setup Archer class skills"""
	skills.clear()
	
	var arrow = Skill.new()
	arrow.skill_name = "Multi-Shot"
	arrow.skill_description = "Fire multiple arrows"
	arrow.base_damage = 35
	arrow.mana_cost = 15
	arrow.cooldown = 3.0
	arrow.effect_color = Color(0.6, 0.4, 0.2)
	arrow.effect_size = 30.0
	skills.append(arrow)
	
	var explosive = Skill.new()
	explosive.skill_name = "Explosive Arrow"
	explosive.skill_description = "Arrow that explodes on impact"
	explosive.base_damage = 40
	explosive.mana_cost = 20
	explosive.cooldown = 5.0
	explosive.effect_color = Color(1, 0.6, 0)
	explosive.effect_size = 45.0
	skills.append(explosive)
