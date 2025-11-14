extends Resource
class_name Skill

# Basic skill properties
@export var skill_name: String = "Basic Skill"
@export var skill_description: String = "A basic skill"
@export var skill_type: String = "damage"  # damage, heal, buff
@export var skill_icon_color: Color = Color(1, 1, 1)

# Skill stats
@export var base_damage: int = 20
@export var mana_cost: int = 10
@export var cooldown: float = 2.0
@export var cast_time: float = 0.5
@export var skill_range: float = 100.0

# Upgrade system
@export var skill_level: int = 1
@export var max_level: int = 5

# Effect visuals
@export var effect_color: Color = Color(1, 0.5, 0)
@export var effect_size: float = 30.0

# Cooldown tracking (not saved)
var current_cooldown: float = 0.0

func _init():
	pass

func get_damage() -> int:
	"""Calculate damage based on level"""
	return base_damage + (skill_level - 1) * 5

func get_mana_cost() -> int:
	"""Calculate mana cost based on level"""
	return mana_cost + (skill_level - 1) * 2

func get_cooldown() -> float:
	"""Get cooldown time"""
	return cooldown

func can_upgrade() -> bool:
	"""Check if skill can be upgraded"""
	return skill_level < max_level

func upgrade():
	"""Upgrade the skill to next level"""
	if can_upgrade():
		skill_level += 1
		return true
	return false

func is_ready() -> bool:
	"""Check if skill is off cooldown"""
	return current_cooldown <= 0.0

func start_cooldown():
	"""Start the cooldown timer"""
	current_cooldown = get_cooldown()

func update_cooldown(delta: float):
	"""Update cooldown timer"""
	if current_cooldown > 0:
		current_cooldown -= delta
		if current_cooldown < 0:
			current_cooldown = 0

func duplicate_skill() -> Skill:
	"""Create a copy of this skill"""
	var new_skill = Skill.new()
	new_skill.skill_name = skill_name
	new_skill.skill_description = skill_description
	new_skill.skill_type = skill_type
	new_skill.skill_icon_color = skill_icon_color
	new_skill.base_damage = base_damage
	new_skill.mana_cost = mana_cost
	new_skill.cooldown = cooldown
	new_skill.cast_time = cast_time
	new_skill.skill_range = skill_range
	new_skill.skill_level = skill_level
	new_skill.max_level = max_level
	new_skill.effect_color = effect_color
	new_skill.effect_size = effect_size
	return new_skill
