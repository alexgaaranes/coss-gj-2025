extends Node

@export var max_points := 5000 #TODO: placeholder values only
@export var points_per_tupperware := 1000 #TODO: placeholder values only

@export var timer_countdown := 120 #TODO: replace this with actual time limit, this is for testing only




var points: int = 0
var time_left: float = 0.0
var game_over: bool = false
var capacity: float = 0.0
var max_capacity: float = 100.0



@onready var hud := $HUD

func _ready() -> void:
	randomize() 
	var npc1_scene = preload("res://scenes/npc/npc_followpath2d.tscn")
	var npc2_scene = preload("res://scenes/npc/npc_followpath2d.tscn")
	var npc3_scene = preload("res://scenes/npc/npc_followpath2d.tscn")
	
	var npc1 = npc1_scene.instantiate()
	var npc2 = npc1_scene.instantiate()
	var npc3 = npc1_scene.instantiate()
	
	npc1.position = Vector2(-100, 375)
	npc2.position = Vector2(500, 375)
	npc3.position = Vector2(1200, 375)
	
	# get the available sprite frames
	var available_sprite_frames: Array[SpriteFrames] = [
		load("res://assets/npc_sprites/bata_frames.tres"),
		load("res://assets/npc_sprites/lola_frames.tres"),
		load("res://assets/npc_sprites/tita_frames.tres"),
		load("res://assets/npc_sprites/tito_frames.tres")
	]
	available_sprite_frames.shuffle()
	
	# get the node of an empty animatedsprite2d
	var npc1_animated_sprite_node: AnimatedSprite2D = npc1.get_node("PathFollow2D/AnimatedSprite2D")
	var npc2_animated_sprite_node: AnimatedSprite2D = npc2.get_node("PathFollow2D/AnimatedSprite2D") 
	var npc3_animated_sprite_node: AnimatedSprite2D = npc3.get_node("PathFollow2D/AnimatedSprite2D") 
	
	# array of animatedsprite2d nodes
	var npc_animated_sprites_nodes = [
		npc1_animated_sprite_node,
		npc2_animated_sprite_node,
		npc3_animated_sprite_node
	]
	
	# assign each animatedsprite2d node with a random sprite frame
	for i in range(npc_animated_sprites_nodes.size()):
		var current_npc_sprite_node = npc_animated_sprites_nodes[i]
		
		if current_npc_sprite_node and not available_sprite_frames.is_empty():
			var chosen_frames = available_sprite_frames.pop_front() 
			
			current_npc_sprite_node.sprite_frames = chosen_frames
			current_npc_sprite_node.animation = "idle" 
			current_npc_sprite_node.play()
		else:
			print("invalid frames")
	
	print(available_sprite_frames)
	
	# all dialogues
	var bata_dialogues = [
		"Napakakalbo niya, bagay sa kaniya",
		"Ang kulit niya! Sarap kurutin",
		"Nakapambahay! Di man lang nag damit nang maayos",
		"Grade 4 pa lang ata siya"
	]
	bata_dialogues.shuffle()
	
	var lola_dialogues = [
		"Di halatang matanda, super lakas pa niya!",
		"Lagi nalang siyang may discount sa lahat",
		"Laging may dalang good vibes, parang kasabay ng kulay niya",
		"Asawa siya ni Lolo!"
	]
	lola_dialogues.shuffle()
	
	var tita_dialogues = [
		"Uyyy single ba siya?",
		"Kagandahan niya'y kahanga-hanga",
		"Andito nanaman si marites"
	]
	
	var tito_dialogues = [
		"Ang ganda ng ngiti parang Kpop idol",
		"Para siyang nagcosplay ng eggplant",
		"Napaka Gen Z ng suot niya kainis",
	]
	print("npc1 dialogue: ", npc1.get_node("PathFollow2D").npc_dialogue_text)
	if available_sprite_frames == [load("res://assets/npc_sprites/bata_frames.tres")]:
		npc1.get_node("PathFollow2D").npc_dialogue_text = bata_dialogues[0]
		npc2.get_node("PathFollow2D").npc_dialogue_text = bata_dialogues[1]
		npc3.get_node("PathFollow2D").npc_dialogue_text = bata_dialogues[2]
	if available_sprite_frames == [load("res://assets/npc_sprites/lola_frames.tres")]:
		npc1.get_node("PathFollow2D").npc_dialogue_text = lola_dialogues[0]
		npc2.get_node("PathFollow2D").npc_dialogue_text = lola_dialogues[1]
		npc3.get_node("PathFollow2D").npc_dialogue_text = lola_dialogues[2]
	if available_sprite_frames == [load("res://assets/npc_sprites/tita_frames.tres")]:
		npc1.get_node("PathFollow2D").npc_dialogue_text = tita_dialogues[0]
		npc2.get_node("PathFollow2D").npc_dialogue_text = tita_dialogues[1]
		npc3.get_node("PathFollow2D").npc_dialogue_text = tita_dialogues[2]
	if available_sprite_frames == [load("res://assets/npc_sprites/tito_frames.tres")]:
		npc1.get_node("PathFollow2D").npc_dialogue_text = tito_dialogues[0]
		npc2.get_node("PathFollow2D").npc_dialogue_text = tito_dialogues[1]
		npc3.get_node("PathFollow2D").npc_dialogue_text = tito_dialogues[2]
	
	var npc_arrs = [npc1, npc2, npc3]
	
	for npc in npc_arrs:
		if npc.get_node("PathFollow2D/AnimatedSprite2D").sprite_frames == load("res://assets/npc_sprites/bata_frames.tres"):
			npc.get_node("PathFollow2D/CharacterBody2D/NpcDialogue/MarginContainer").position = Vector2(-226.11, -112.0)
		if npc.get_node("PathFollow2D/AnimatedSprite2D").sprite_frames == load("res://assets/npc_sprites/lola_frames.tres"):
			npc.get_node("PathFollow2D/CharacterBody2D/NpcDialogue/MarginContainer").position = Vector2(-226.11, -272.0)
		if npc.get_node("PathFollow2D/AnimatedSprite2D").sprite_frames == load("res://assets/npc_sprites/tita_frames.tres"):
			npc.get_node("PathFollow2D/CharacterBody2D/NpcDialogue/MarginContainer").position = Vector2(-226.11,-226.11)
		if npc.get_node("PathFollow2D/AnimatedSprite2D").sprite_frames == load("res://assets/npc_sprites/tito_frames.tres"):
			npc.get_node("PathFollow2D/CharacterBody2D/NpcDialogue/MarginContainer").position = Vector2(-226.11, -232.0)
	
	add_child(npc1)
	add_child(npc2)
	add_child(npc3)
	
	time_left = timer_countdown
	points = 0
	game_over = false
	
	GlobalSignals.game_lost_triggered.connect(self._on_game_lost_triggered)
	
	GlobalSignals.connect("has_successfully_sharon", self._on_successful_sharon)
	
	hud.hide_all_status_panels()

	hud.update_timer_label(time_left)
	
	GlobalSignals.connect("is_finished_stealing_food", self.add_points)

	#test_points_sequence()  uncomment this for testing of win condition

func _process(delta: float) -> void:
	if game_over:
		return

	if time_left > 0:
		time_left -= delta
		if time_left < 0:
			time_left = 0
		hud.update_timer_label(time_left)
		
	if time_left == 0:
		game_lost()  

func add_points(amount: int) -> void:
	if game_over:
		return

	points = clamp(points + amount, 0, max_points)
	hud.update_tupperwares(points, max_points, points_per_tupperware)
	print("Points: " + str(points))
	if points >= max_points:
		game_won()
		
func add_weight(amount: float) -> void:
	if game_over:
		return
		
	capacity = clamp(capacity + amount, 0, max_capacity)
	hud.update_inventory(capacity)

func player_caught() -> void:
	if game_over:
		return

	game_lost()

func game_won() -> void:
	game_over = true
	print("You won! Max points reached")
	hud.show_game_win() 
	get_tree().paused = true

func game_lost() -> void:
	game_over = true
	print("Game Over!")
	hud.show_game_over() 
	get_tree().paused = true

func _on_game_lost_triggered() -> void:
	game_over = true
	print("Game Over!")
	hud.show_game_over() 
	get_tree().paused = true
	
#uncomment this function for testing of winning condition
#func test_points_sequence() -> void:
	#var test_points = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
	#for pts in test_points:
		#print("Testing points: ", pts)
		#add_points(pts - points)
		#await get_tree().create_timer(1.0).timeout

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/menu.tscn")
	
func _on_successful_sharon(data: Dictionary) -> void:
	add_points(data["points"])
	add_weight(data["weight"])
