extends Node2D

@export var effect_color: Color = Color(1, 0.5, 0)
@export var effect_size: float = 30.0
@export var lifetime: float = 0.5

var time_alive: float = 0.0

@onready var visual = $Visual

func _ready():
	if visual:
		visual.color = effect_color
		visual.size = Vector2(effect_size, effect_size)
		visual.position = -visual.size / 2  # Center the rect

func _process(delta):
	time_alive += delta
	
	# Fade out effect
	if visual:
		var alpha = 1.0 - (time_alive / lifetime)
		visual.modulate.a = alpha
	
	# Expand effect
	if visual:
		var scale_factor = 1.0 + (time_alive / lifetime) * 0.5
		visual.scale = Vector2(scale_factor, scale_factor)
	
	# Remove when lifetime is up
	if time_alive >= lifetime:
		queue_free()

func setup(color: Color, size: float):
	"""Setup the effect with custom parameters"""
	effect_color = color
	effect_size = size
	if visual:
		visual.color = effect_color
		visual.size = Vector2(effect_size, effect_size)
		visual.position = -visual.size / 2
