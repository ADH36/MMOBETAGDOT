extends CharacterBody2D

# NPC properties
@export var npc_name: String = "Villager"
@export var npc_type: String = "merchant"  # merchant, quest_giver, generic
@export var dialogue_text: String = "Hello, traveler!"
@export var move_speed: float = 50.0

# Runtime state
var state: String = "idle"  # idle, walk
var walk_timer: float = 0.0
var walk_direction: Vector2 = Vector2.ZERO
var interaction_cooldown: float = 0.0

# Visual components
@onready var name_label = $NameLabel
@onready var npc_sprite = $NPCSprite
@onready var interaction_hint = $InteractionHint

# Interaction area
var player_in_range: bool = false
var nearby_player = null

func _ready():
	if name_label:
		name_label.text = npc_name
	_setup_appearance()
	choose_random_walk()
	
	# Hide interaction hint initially
	if interaction_hint:
		interaction_hint.visible = false
	
	# Add to NPCs group
	add_to_group("npcs")

func _physics_process(delta):
	# Update timers
	if interaction_cooldown > 0:
		interaction_cooldown -= delta
	
	# AI behavior
	update_ai(delta)
	
	# Move
	move_and_slide()
	
	# Check for interaction input
	if player_in_range and Input.is_action_just_pressed("ui_accept"):  # E key or Enter
		interact()

func _setup_appearance():
	"""Setup NPC visual appearance based on type"""
	if npc_sprite:
		match npc_type:
			"merchant":
				npc_sprite.modulate = Color(0.6, 0.4, 0.8)  # Purple for merchants
			"quest_giver":
				npc_sprite.modulate = Color(0.8, 0.6, 0.2)  # Gold for quest givers
			"generic":
				npc_sprite.modulate = Color(0.4, 0.5, 0.6)  # Blue-gray for generic NPCs

func update_ai(delta):
	"""Simple AI for NPC movement"""
	match state:
		"idle":
			velocity = Vector2.ZERO
			walk_timer -= delta
			if walk_timer <= 0:
				state = "walk"
				choose_random_walk()
		
		"walk":
			velocity = walk_direction * move_speed
			walk_timer -= delta
			if walk_timer <= 0:
				state = "idle"
				walk_timer = randf_range(2.0, 5.0)

func choose_random_walk():
	"""Choose a random walk direction"""
	var angle = randf() * TAU
	walk_direction = Vector2(cos(angle), sin(angle))
	walk_timer = randf_range(1.5, 3.5)

func interact():
	"""Handle interaction with player"""
	if interaction_cooldown > 0:
		return
	
	interaction_cooldown = 1.0
	
	match npc_type:
		"merchant":
			show_merchant_dialogue()
		"quest_giver":
			show_quest_dialogue()
		"generic":
			show_generic_dialogue()

func show_merchant_dialogue():
	"""Show merchant-specific dialogue"""
	print("=== MERCHANT: ", npc_name, " ===")
	print(dialogue_text)
	print("Shop coming soon!")
	print("======================")

func show_quest_dialogue():
	"""Show quest giver dialogue"""
	print("=== QUEST GIVER: ", npc_name, " ===")
	print(dialogue_text)
	print("Quests coming soon!")
	print("======================")

func show_generic_dialogue():
	"""Show generic NPC dialogue"""
	print("=== ", npc_name, " ===")
	print(dialogue_text)
	print("======================")

func _on_interaction_area_body_entered(body):
	"""Player entered interaction range"""
	if body.is_in_group("players") and body.is_local_player:
		player_in_range = true
		nearby_player = body
		if interaction_hint:
			interaction_hint.visible = true

func _on_interaction_area_body_exited(body):
	"""Player left interaction range"""
	if body.is_in_group("players") and body.is_local_player:
		player_in_range = false
		nearby_player = null
		if interaction_hint:
			interaction_hint.visible = false
