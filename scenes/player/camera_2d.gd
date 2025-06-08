
extends Camera2D

var shake_strength = 0.0
var shake_decay = 10.0
var zoom_tween: Tween = null
var pan_tween: Tween = null

func _ready():
	GlobalSignals.connect("shake_camera", self.start_shake)
	GlobalSignals.connect("is_stealing_food", self.shrink_cam)
	GlobalSignals.connect("is_finished_stealing_food", self.reset_cam_zoom)
	GlobalSignals.connect("has_failed_stealing_food", self.reset_cam_zoom)
	GlobalSignals.connect("pan_camera", self._on_camera_pan)

func _process(delta):
	# camera shake
	if shake_strength > 0:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO

func start_shake(strength: float):
	shake_strength = strength

func shrink_cam():
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.set_ease(Tween.EASE_OUT)
	zoom_tween.tween_property(self, "zoom", Vector2(1.5,1.5), 1)
	
func reset_cam_zoom():
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.set_ease(Tween.EASE_IN)
	zoom_tween.tween_property(self, "zoom", Vector2(1,1), 0.5)
	
func _on_camera_pan(position):
	if pan_tween:
		pan_tween.kill()
	
	pan_tween = create_tween()
	pan_tween.set_trans(Tween.TRANS_LINEAR)
	pan_tween.set_ease(Tween.EASE_IN_OUT)
	
	var host_position := Vector2(position.x, position.y - 100)
	
	pan_tween.tween_property(self, "global_position",host_position, 1.5)
