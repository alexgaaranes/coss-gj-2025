extends Node

@export var max_points := 5000 #TODO: placeholder values only
@export var points_per_tupperware := 1000 #TODO: placeholder values only
@export var timer_countdown := 2 #TODO: replace this with actual time limit, this is for testing only

var points: int = 0
var time_left: float = 0.0
var game_over: bool = false

@onready var hud := $HUD

func _ready() -> void:
	time_left = timer_countdown
	points = 0
	game_over = false
	
	hud.hide_all_status_panels()
	hud.update_tupperwares(points, max_points, points_per_tupperware)
	hud.update_timer_label(time_left)

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

	if points >= max_points:
		game_won()

func player_caught() -> void:
	if game_over:
		return

	game_lost()

func game_won() -> void:
	game_over = true
	print("You won! Max points reached")
	hud.show_game_win() 

func game_lost() -> void:
	game_over = true
	print("Game Over!")
	hud.show_game_over() 
#uncomment this function for testing of winning condition
#func test_points_sequence() -> void:
	#var test_points = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
	#for pts in test_points:
		#print("Testing points: ", pts)
		#add_points(pts - points)
		#await get_tree().create_timer(1.0).timeout

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/menu.tscn")
