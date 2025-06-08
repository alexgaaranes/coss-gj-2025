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
	replace_map_scene(get_node('Map'), new_map_scene.instantiate())

func replace_map_scene(map_scene: Node2D, new_map_scene: Node2D):
	add_child(new_map_scene)
	var player = map_scene.get_node("Player")
	new_map_scene.add_child(player)
	move_child(new_map_scene, 0)
	remove_child(map_scene)
	new_map_scene.name = "Map"
	print($Map.get_children())
	
	new_map_scene.position = map_scene.position
	new_map_scene.rotation = map_scene.rotation
	new_map_scene.scale = map_scene.scale
	map_scene.queue_free()
	
