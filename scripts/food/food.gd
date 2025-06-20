extends Node2D

var is_overlapping = false
var has_timer = false
var is_stealing = false
var player = null

@export var points := 100
@export var weight := 2.5

func _on_area_2d_area_entered(area):
	if area.get_parent().name == "Player":
		player = area.get_parent()
		GlobalSignals.emit_signal("is_overlapping_food")
		is_overlapping = true

func _ready():
	GlobalSignals.connect("is_stealing_food", self._on_stealing)
	GlobalSignals.connect("is_finished_stealing_food", self._on_exit_stealing)
	GlobalSignals.connect("has_failed_stealing_food", self._on_exit_stealing)
	GlobalSignals.connect("set_overlapping", self.set_overlapping)
	GlobalSignals.close_timer.connect(self._on_close_timer_triggered)

func _process(delta):
	if player != null and player.velocity != Vector2.ZERO:
		if is_stealing:
			del_timer()
			GlobalSignals.emit_signal("has_failed_stealing_food")
			is_overlapping = true	# only for this 
		else:
			return
	if Input.is_action_just_released("interact_food") and is_overlapping:
		spawn_timer()
		GlobalSignals.emit_signal("play_sound", "InteractFood")
		GlobalSignals.emit_signal("is_stealing_food")
	if Input.is_action_just_released("stop_steal") and is_stealing:
		del_timer()
		GlobalSignals.emit_signal("play_sound", "InteractFood")
		GlobalSignals.emit_signal("has_failed_stealing_food")
		is_overlapping = true	# only for this 

func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		GlobalSignals.emit_signal("is_not_overlapping_food")
		GlobalSignals.emit_signal("is_finished_stealing_food")
		player = null
		del_timer()

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

func _on_stealing():
	is_stealing = true

func _on_exit_stealing():
	is_stealing = false

func del_timer():
	var timer = get_tree().root.get_node("Timer")
	if timer != null: timer.queue_free()
	is_overlapping = false
	has_timer = false
	
func _on_close_timer_triggered() -> void:
	GlobalSignals.emit_signal("has_failed_stealing_food")
	is_overlapping = true	# only for this 
	var timer = get_tree().root.get_node("Timer")
	if timer != null: timer.queue_free()
	is_overlapping = false
	has_timer = false

func set_overlapping(boolean):
	if player == null: return
	is_overlapping = boolean
