extends Node2D

func _ready():
	var random_map = randi_range(1,3)
	var new_map_scene = null
	
	var current_map = get_node('Map')
		
	var player = current_map.get_node("Player")
	if player: # check if player is not null
		current_map.remove_child(player) # Remove player from the old map
	else:
		return
	
	if random_map == 2:
		new_map_scene = preload("res://scenes/maps/birthday.tscn")
		print("birthday stage")
	elif random_map == 3:
		new_map_scene = preload("res://scenes/maps/indoor.tscn")
		print("indoor stage")
	else: # 1
		new_map_scene = preload("res://scenes/maps/fiesta.tscn")
		print("fiesta stage")
	replace_map_scene(current_map, new_map_scene.instantiate(), player)

func replace_map_scene(map_scene: Node2D, new_map_scene: Node2D, player: Node2D):
	add_child(new_map_scene)
	print("Player: ", player)
	new_map_scene.add_child(player) 
	print("new map scene", new_map_scene)
	new_map_scene.position = map_scene.position
	new_map_scene.rotation = map_scene.rotation
	new_map_scene.scale = map_scene.scale
	new_map_scene.name = "Map"
	move_child(new_map_scene, 0)
	
	print($Map.get_children())
	map_scene.queue_free()
	
