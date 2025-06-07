extends CanvasLayer

@onready var tupper_cont := $TupperContainer
@onready var timer_label := $Timer
@onready var tupper_row := $TupperRow
@onready var bag_holder := $BagHolder

@onready var game_over_panel := $GameOverPanel
@onready var game_win_panel := $GameWinPanel


@onready var restart_button_over := $GameOverPanel/ButtonContainer/RestartButton
@onready var menu_button_over := $GameOverPanel/ButtonContainer/ReturnButton
@onready var restart_button_win := $GameWinPanel/ButtonContainer/RestartButton
@onready var menu_button_win := $GameWinPanel/ButtonContainer/ReturnButton

@export var Max_Capacity := 100.0

var clip_max_height = 80
var clip_initial_height = 0

var bag_max_height = 104

func update_timer_label(time_left: float) -> void:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_tupperwares(points: int, max_points: int, points_per: int) -> void:
	points = clamp(points, 0, max_points)
	
	for i in range(tupper_row.get_child_count()):
		var breakpoints = i * 1000
		# Points of each tupperware, max = 1000, min = 0
		var points_each = clamp(points - breakpoints, 0, points_per)
		
		var tupperware = tupper_row.get_child(i)
		var clip_mask: Control = tupperware.get_node("ClipMask")
		
		var points_percentage: float = float(points_each) / float(points_per)
		
		var fill_height = points_percentage * clip_max_height
		clip_mask.size = Vector2(clip_mask.size.x, fill_height)
		clip_mask.position.y = clip_max_height - fill_height + 15

# TODO: Add functionality
func update_inventory(weight: float):
	weight = clamp(weight, 0, Max_Capacity)
	
	var clip_mask: Control = bag_holder.get_node("ClipMask")
	
	var weight_percentage := weight / Max_Capacity
	var fill_height = weight_percentage * bag_max_height
	clip_mask.size = Vector2(clip_mask.size.x, fill_height)
	clip_mask.position.y = clip_max_height - fill_height + 25
	pass

func show_game_over() -> void:
	game_over_panel.visible = true

func show_game_win() -> void:
	game_win_panel.visible = true

func hide_all_status_panels() -> void:
	game_over_panel.visible = false
	game_win_panel.visible = false
	
