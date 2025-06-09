extends Sprite2D

@onready var tween = get_parent().create_tween()

func _ready():
	loop_animation()

func loop_animation():
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "scale", Vector2(0.2, 0.2), 0.5)
	tween.tween_property(self, "scale", Vector2(0.22, 0.22), 0.5)
