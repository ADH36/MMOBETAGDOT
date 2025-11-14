extends CharacterBody2D

# Monster properties
@export var monster_name: String = "Slime"
@export var monster_type: String = "basic"  # basic, elite, boss
@export var max_health: int = 50
@export var move_speed: float = 80.0
@export var attack_damage: int = 5
@export var detection_range: float = 150.0
@export var attack_range: float = 40.0
@export var gold_drop_min: int = 1
@export var gold_drop_max: int = 5

# Runtime stats
var current_health: int = 50
var is_dead: bool = false
var target_player = null
var state: String = "idle"  # idle, patrol, chase, attack, dead

# AI parameters
var patrol_timer: float = 0.0
var patrol_direction: Vector2 = Vector2.ZERO
var attack_cooldown: float = 0.0
var respawn_timer: float = 0.0
const RESPAWN_TIME: float = 10.0

# Visual components
@onready var name_label = $NameLabel
@onready var health_bar = $HealthBar
@onready var monster_sprite = $MonsterSprite

func _ready():
	current_health = max_health
	if name_label:
		name_label.text = monster_name
	update_health_bar()
	_setup_appearance()
	choose_random_patrol()
	# Add to monsters group for easy access
	add_to_group("monsters")

func _physics_process(delta):
	if is_dead:
		handle_respawn(delta)
		return
	
	# Update timers
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	# AI behavior
	update_ai(delta)
	
	# Move
	move_and_slide()

func _setup_appearance():
	"""Setup monster visual appearance based on type"""
	if monster_sprite:
		match monster_type:
			"basic":
				monster_sprite.modulate = Color(0.3, 0.8, 0.3)  # Green for basic
			"elite":
				monster_sprite.modulate = Color(0.8, 0.5, 0.2)  # Orange for elite
			"boss":
				monster_sprite.modulate = Color(0.8, 0.2, 0.2)  # Red for boss

func update_ai(delta):
	"""Main AI logic"""
	# Find nearest player
	find_target_player()
	
	match state:
		"idle":
			velocity = Vector2.ZERO
			patrol_timer -= delta
			if patrol_timer <= 0:
				state = "patrol"
				choose_random_patrol()
		
		"patrol":
			velocity = patrol_direction * move_speed
			patrol_timer -= delta
			if patrol_timer <= 0:
				state = "idle"
				patrol_timer = randf_range(1.0, 3.0)
		
		"chase":
			if target_player and is_instance_valid(target_player):
				var direction = (target_player.global_position - global_position).normalized()
				velocity = direction * move_speed * 1.2  # Faster when chasing
				
				# Check if in attack range
				var distance = global_position.distance_to(target_player.global_position)
				if distance <= attack_range:
					state = "attack"
					velocity = Vector2.ZERO
			else:
				state = "idle"
				patrol_timer = randf_range(1.0, 2.0)
		
		"attack":
			velocity = Vector2.ZERO
			if target_player and is_instance_valid(target_player):
				var distance = global_position.distance_to(target_player.global_position)
				if distance > attack_range:
					state = "chase"
				elif attack_cooldown <= 0:
					perform_attack()
			else:
				state = "idle"

func find_target_player():
	"""Find the nearest player within detection range"""
	if state == "dead":
		return
	
	var players = get_tree().get_nodes_in_group("players")
	var nearest_player = null
	var nearest_distance = detection_range
	
	for player in players:
		if player and is_instance_valid(player):
			var distance = global_position.distance_to(player.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_player = player
	
	if nearest_player:
		target_player = nearest_player
		if state in ["idle", "patrol"]:
			state = "chase"
	elif state == "chase":
		state = "idle"
		patrol_timer = randf_range(1.0, 2.0)

func choose_random_patrol():
	"""Choose a random patrol direction"""
	var angle = randf() * TAU
	patrol_direction = Vector2(cos(angle), sin(angle))
	patrol_timer = randf_range(2.0, 4.0)

func perform_attack():
	"""Attack the target player"""
	attack_cooldown = 1.5
	if target_player and is_instance_valid(target_player):
		# Deal damage to player (if player has take_damage method)
		if target_player.has_method("take_damage"):
			target_player.take_damage(attack_damage)
		print(monster_name, " attacks for ", attack_damage, " damage!")

func take_damage(damage: int):
	"""Monster takes damage"""
	if is_dead:
		return
	
	current_health -= damage
	update_health_bar()
	
	print(monster_name, " took ", damage, " damage! Health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		die()

func die():
	"""Handle monster death"""
	if is_dead:
		return
	
	is_dead = true
	state = "dead"
	current_health = 0
	
	# Drop gold
	var gold_amount = randi_range(gold_drop_min, gold_drop_max)
	CurrencyManager.add_gold(gold_amount)
	
	# Hide monster
	visible = false
	set_physics_process(false)
	
	# Start respawn timer
	respawn_timer = RESPAWN_TIME
	
	print(monster_name, " died! Dropped ", gold_amount, " gold.")

func handle_respawn(delta):
	"""Handle monster respawn"""
	respawn_timer -= delta
	if respawn_timer <= 0:
		respawn()

func respawn():
	"""Respawn the monster"""
	is_dead = false
	current_health = max_health
	state = "idle"
	patrol_timer = randf_range(1.0, 3.0)
	visible = true
	set_physics_process(true)
	update_health_bar()
	choose_random_patrol()
	print(monster_name, " respawned!")

func update_health_bar():
	"""Update health bar display"""
	if health_bar:
		var health_percent = float(current_health) / float(max_health)
		health_bar.value = health_percent * 100
		
		# Change color based on health
		if health_percent > 0.5:
			health_bar.modulate = Color(0.2, 0.8, 0.2)  # Green
		elif health_percent > 0.25:
			health_bar.modulate = Color(0.8, 0.8, 0.2)  # Yellow
		else:
			health_bar.modulate = Color(0.8, 0.2, 0.2)  # Red
