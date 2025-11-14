extends Node2D
class_name WorldDecoration

# This script creates simple decorations for different world types

func create_jungle_decorations(world_bounds: Rect2):
	"""Create jungle decorations like trees and bushes"""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Create trees
	for i in range(15):
		var tree = create_tree()
		tree.position = Vector2(
			rng.randf_range(world_bounds.position.x, world_bounds.end.x),
			rng.randf_range(world_bounds.position.y, world_bounds.end.y)
		)
		add_child(tree)
	
	# Create bushes
	for i in range(20):
		var bush = create_bush()
		bush.position = Vector2(
			rng.randf_range(world_bounds.position.x, world_bounds.end.x),
			rng.randf_range(world_bounds.position.y, world_bounds.end.y)
		)
		add_child(bush)

func create_village_decorations(world_bounds: Rect2):
	"""Create village decorations like houses and paths"""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Create houses
	for i in range(5):
		var house = create_house()
		house.position = Vector2(
			rng.randf_range(world_bounds.position.x + 100, world_bounds.end.x - 100),
			rng.randf_range(world_bounds.position.y + 100, world_bounds.end.y - 100)
		)
		add_child(house)
	
	# Create fences
	for i in range(10):
		var fence = create_fence()
		fence.position = Vector2(
			rng.randf_range(world_bounds.position.x, world_bounds.end.x),
			rng.randf_range(world_bounds.position.y, world_bounds.end.y)
		)
		add_child(fence)

func create_tree() -> Node2D:
	"""Create a simple tree"""
	var tree = Node2D.new()
	
	# Trunk
	var trunk = ColorRect.new()
	trunk.size = Vector2(10, 30)
	trunk.position = Vector2(-5, -30)
	trunk.color = Color(0.4, 0.2, 0.1)
	tree.add_child(trunk)
	
	# Leaves
	var leaves = ColorRect.new()
	leaves.size = Vector2(30, 30)
	leaves.position = Vector2(-15, -50)
	leaves.color = Color(0.1, 0.5, 0.1)
	tree.add_child(leaves)
	
	return tree

func create_bush() -> Node2D:
	"""Create a simple bush"""
	var bush = Node2D.new()
	
	var rect = ColorRect.new()
	rect.size = Vector2(20, 15)
	rect.position = Vector2(-10, -15)
	rect.color = Color(0.15, 0.4, 0.15)
	bush.add_child(rect)
	
	return bush

func create_house() -> Node2D:
	"""Create a simple house"""
	var house = Node2D.new()
	
	# Walls
	var walls = ColorRect.new()
	walls.size = Vector2(60, 50)
	walls.position = Vector2(-30, -50)
	walls.color = Color(0.7, 0.5, 0.3)
	house.add_child(walls)
	
	# Roof
	var roof = ColorRect.new()
	roof.size = Vector2(70, 20)
	roof.position = Vector2(-35, -70)
	roof.color = Color(0.5, 0.2, 0.1)
	house.add_child(roof)
	
	# Door
	var door = ColorRect.new()
	door.size = Vector2(15, 25)
	door.position = Vector2(-7, -30)
	door.color = Color(0.3, 0.2, 0.1)
	house.add_child(door)
	
	return house

func create_fence() -> Node2D:
	"""Create a simple fence"""
	var fence = Node2D.new()
	
	var rect = ColorRect.new()
	rect.size = Vector2(40, 15)
	rect.position = Vector2(-20, -15)
	rect.color = Color(0.5, 0.3, 0.2)
	fence.add_child(rect)
	
	return fence

func clear_decorations():
	"""Remove all decorations"""
	for child in get_children():
		child.queue_free()
