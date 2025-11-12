extends CharacterBody2D

const SPEED = 200.0

var player_name = "Player"
var is_local_player = false

@onready var name_label = $NameLabel

func _ready():
	if name_label:
		name_label.text = player_name

func _physics_process(delta):
	if is_local_player:
		handle_input()
		move_and_slide()
		
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

func set_player_name(new_name: String):
	player_name = new_name
	if name_label:
		name_label.text = player_name

func set_position_smooth(new_position: Vector2):
	# Smooth interpolation for network players
	if not is_local_player:
		var tween = create_tween()
		tween.tween_property(self, "global_position", new_position, 0.1)
