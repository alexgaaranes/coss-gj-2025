extends CanvasLayer

@onready var bar = $BarContainer
@onready var arrow = $BarContainer/Arrow
@onready var zone = $BarContainer/Zone
@onready var bar_bg = $BarContainer/Bar

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
	var arrow_pos = arrow.position.x
	var zone_pos = zone.position.x
	var zone_width = zone.size.x # replace with zone.get_size().x when replaced with sprite

	return arrow_pos >= zone_pos and arrow_pos <= zone_pos + zone_width

func _input(event):
	if not is_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		if tween:
			tween.kill()
		if skill_check():
			print("Skill Check Successful!")
			input_feedback(true)
		else:
			print("Skill Check Failed")
			input_feedback(false)
		is_active = false
		

	elif event.is_action_pressed("ui_cancel"):
		print("Skill Check Cancelled")
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
	print("Feedback animation finished.")
	hide()
	bar.scale = Vector2(1, 1) # reset scale just in case
	
	get_parent().queue_free()

func _cancel_skill_check():
	if tween:
		tween.kill()
	if feedback_tween:
		feedback_tween.kill()

	bar.scale = Vector2(1, 1)
	hide()
