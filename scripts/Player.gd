extends CharacterBody2D

const SPEED = 200.0

var player_name = "Player"
var is_local_player = false
var character_data: CharacterData
var attack_effect_scene = preload("res://scenes/AttackEffect.tscn")

@onready var name_label = $NameLabel
@onready var body_sprite = $Body
@onready var head_sprite = $Head
@onready var hair_sprite = $Hair
@onready var outfit_sprite = $Outfit

func _ready():
	if name_label:
		name_label.text = player_name
	_setup_default_appearance()
	# Add to players group for monster AI targeting
	add_to_group("players")

func _physics_process(delta):
	if is_local_player:
		handle_input()
		handle_combat_input()
		move_and_slide()
		
		# Update cooldowns
		if character_data:
			character_data.update_attack_cooldown(delta)
			character_data.update_skills_cooldown(delta)
		
		# Send position to server periodically
		if Engine.get_physics_frames() % 5 == 0:  # Every 5 frames
			NetworkManager.send_position(global_position)

func handle_input():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	
	input_vector = input_vector.normalized()
	velocity = input_vector * SPEED

func handle_combat_input():
	"""Handle attack and skill inputs"""
	if not character_data:
		return
	
	# Basic attack
	if Input.is_action_just_pressed("attack"):
		perform_attack()
	
	# Skills
	if Input.is_action_just_pressed("skill_1"):
		cast_skill(0)
	if Input.is_action_just_pressed("skill_2"):
		cast_skill(1)
	if Input.is_action_just_pressed("skill_3"):
		cast_skill(2)

func perform_attack():
	"""Perform basic attack"""
	if not character_data.is_attack_ready():
		return
	
	character_data.start_attack_cooldown()
	
	# Create attack effect
	var effect = attack_effect_scene.instantiate()
	effect.global_position = global_position + Vector2(30, 0)  # In front of player
	effect.setup(Color(1, 0.8, 0.2), 25.0)
	get_parent().add_child(effect)
	
	# Check for monsters in attack range and damage them
	var monsters = get_tree().get_nodes_in_group("monsters")
	var attack_range = 60.0
	for monster in monsters:
		if monster and is_instance_valid(monster):
			var distance = global_position.distance_to(monster.global_position)
			if distance <= attack_range and monster.has_method("take_damage"):
				monster.take_damage(character_data.get_attack_damage())
	
	print("Attack! Damage: ", character_data.get_attack_damage())

func cast_skill(skill_index: int):
	"""Cast a skill"""
	if not character_data.can_cast_skill(skill_index):
		return
	
	var skill = character_data.skills[skill_index]
	if character_data.cast_skill(skill_index):
		# Create skill effect
		var effect = attack_effect_scene.instantiate()
		effect.global_position = global_position + Vector2(40, 0)
		effect.setup(skill.effect_color, skill.effect_size)
		get_parent().add_child(effect)
		
		# Check for monsters in skill range and damage them
		var monsters = get_tree().get_nodes_in_group("monsters")
		var skill_range = 80.0
		for monster in monsters:
			if monster and is_instance_valid(monster):
				var distance = global_position.distance_to(monster.global_position)
				if distance <= skill_range and monster.has_method("take_damage"):
					monster.take_damage(skill.get_damage())
		
		print("Cast ", skill.skill_name, "! Damage: ", skill.get_damage(), " Mana: ", character_data.current_mana)

func set_player_name(new_name: String):
	player_name = new_name
	if name_label:
		name_label.text = player_name

func set_position_smooth(new_position: Vector2):
	# Smooth interpolation for network players
	if not is_local_player:
		var tween = create_tween()
		tween.tween_property(self, "global_position", new_position, 0.1)

func update_appearance(char_data: CharacterData):
	"""Update character visual appearance based on character data"""
	character_data = char_data
	
	if body_sprite:
		body_sprite.modulate = char_data.body_color
	if head_sprite:
		head_sprite.modulate = char_data.body_color
	if hair_sprite:
		hair_sprite.modulate = char_data.hair_color_value
	if outfit_sprite:
		outfit_sprite.modulate = char_data.outfit_color

func take_damage(damage: int):
	"""Player takes damage from monster"""
	if not character_data:
		return
	
	character_data.current_health -= damage
	if character_data.current_health < 0:
		character_data.current_health = 0
	
	print(player_name, " took ", damage, " damage! Health: ", character_data.current_health, "/", character_data.max_health)
	
	# Optional: Handle player death
	if character_data.current_health <= 0:
		print(player_name, " has been defeated!")
		# Could implement respawn logic here

func _setup_default_appearance():
	"""Setup default appearance if no character data is provided"""
	if not character_data:
		character_data = CharacterData.new()
		character_data.apply_class_stats()
	update_appearance(character_data)
