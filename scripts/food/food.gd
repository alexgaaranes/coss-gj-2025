extends Node2D

var is_overlapping = false
var has_timer = false

@export var points := 100
@export var weight := 10

func _on_area_2d_area_entered(area):
	is_overlapping = true

func _process(delta):
	if Input.is_action_just_released("interact_food") and is_overlapping:
		spawn_timer()
		GlobalSignals.emit_signal("is_stealing_food")

func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	del_timer()
	is_overlapping = false
	has_timer = false

# other functions
func spawn_timer():
	is_overlapping = false
	var timing_indicator_scene = preload("res://scenes/timing_indicator/timer.tscn")
	var timing_indicator = timing_indicator_scene.instantiate()
	
	# Pass food data to timer
	var timer_canvas = timing_indicator.get_child(0)
	if timer_canvas:
		timer_canvas.set_food({
			"points": points,
			"weight": weight
		})
	
	var screen_size = get_viewport().get_visible_rect().size
	timing_indicator.get_child(0).scale = Vector2(0.4, 0.4)
	get_tree().root.add_child(timing_indicator)
	has_timer = true

func del_timer():
	GlobalSignals.emit_signal("is_finished_stealing_food")
	var timer = get_tree().root.get_node("Timer")
	if timer != null: timer.queue_free()

func set_overlapping(boolean):
	is_overlapping = boolean
