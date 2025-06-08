extends Node2D

func _ready():
	var random_map = randi_range(1,3)
	var new_map_scene = null
	if random_map == 2:
		new_map_scene = preload("res://scenes/maps/birthday.tscn")
	elif random_map == 3:
		new_map_scene = preload("res://scenes/maps/indoor.tscn")
	else:
		return
	var map_scene = new_map_scene.instantiate()
	replace_map_scene($Map, map_scene)

func replace_map_scene(map_scene: Node2D, new_map_scene: Node2D):
	map_scene.replace_by(new_map_scene, true)
	print(map_scene)
	print(new_map_scene)
	print(get_children())
	
	new_map_scene.position = map_scene.position
	new_map_scene.rotation = map_scene.rotation
	new_map_scene.scale = map_scene.scale
	
	map_scene.queue_free()
