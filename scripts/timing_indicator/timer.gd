extends CanvasLayer

@onready var bar = $BarContainer
@onready var arrow = $BarContainer/Arrow
@onready var zone = $BarContainer/Zone
@onready var bar_bg = $BarContainer/Bar

var food := {}

var tween: Tween
var feedback_tween: Tween
var is_active = false

# Arrow speed range
var min_speed = 0.4
var max_speed = 0.7

func _ready():
	hide()  # shows only when interacting with food
	bar_show() # REMOVE WHEN FOOD INTERACTION IS IMPLEMENTED, this is only for testing

func bar_show():
	randomize()
	show()
	is_active = true
	_start_movement()

func _start_movement():
	if tween:
		tween.kill()
	tween = create_tween()

	var bar_width = bar_bg.size.x # replace with bar_bg.get_size().x when replaced with sprite
	var arrow_width = arrow.size.x # replace with arrow.get_size().x when replaced with sprite
	var start_pos = 0
	var end_pos = bar_width - arrow_width
	var duration = randf_range(min_speed, max_speed)

	arrow.position.x = start_pos

	tween.set_loops()
	tween.tween_property(arrow, "position:x", end_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(arrow, "position:x", start_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func skill_check() -> bool:
	var arrow_size = arrow.texture.get_size() * arrow.scale
	var arrow_rect = Rect2(
		arrow.position,
		arrow_size
	)

	var zone_size = zone.size * zone.scale
	var zone_rect = Rect2(
		zone.position,
		zone_size
	)

	return arrow_rect.intersects(zone_rect)

	return arrow_rect.intersects(zone_rect)
func _input(event):
	if not is_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		if tween:
			tween.kill()
		if skill_check():
			add_food_weight()
			GlobalSignals.emit_signal("has_successfully_sharon", food)
			input_feedback(true)
			GlobalSignals.emit_signal("is_finished_stealing_food", 0)
			GlobalSignals.emit_signal("is_finished_stealing_food")
			GlobalSignals.emit_signal("play_sound", "Scoop")
		else:
			input_feedback(false)
			GlobalSignals.emit_signal("has_failed_stealing_food")
			GlobalSignals.emit_signal("play_sound", "FailedScoop")
			GlobalSignals.emit_signal("shake_camera", 5.0)
		is_active = false
		

	elif event.is_action_pressed("ui_cancel"):
		_cancel_skill_check()
		is_active = false

func input_feedback(success: bool):
	if feedback_tween:
		feedback_tween.kill()
	
	feedback_tween = create_tween()
	feedback_tween.tween_property(bar, "scale", Vector2(1.2, 1.2), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	feedback_tween.tween_property(bar, "scale", Vector2(1, 1), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	feedback_tween.tween_callback(Callable(self, "_on_feedback_pause_done")).set_delay(0.5)
func _on_feedback_pause_done():
	_on_feedback_finished()
func _on_feedback_finished():
	hide()
	bar.scale = Vector2(1, 1) # reset scale just in case
	
	get_parent().queue_free()
	GlobalSignals.emit_signal("set_overlapping", true)

func _cancel_skill_check():
	if tween:
		tween.kill()
	if feedback_tween:
		feedback_tween.kill()

	bar.scale = Vector2(1, 1)
	hide()

# TODO: Dynamically add weight with food data
func add_food_weight():
	var player = get_tree().root.get_node("GameLevel").get_node("Map2").get_node('Player')
	player.add_food(food["weight"])
	
func set_food(food_stats: Dictionary):
	food = food_stats
	
func _process(delta):
	if is_active:
		bar_bg.modulate = Color.GREEN if skill_check() else Color.RED
