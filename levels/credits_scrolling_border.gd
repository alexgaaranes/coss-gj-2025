extends ParallaxBackground

@export var scrolling_speed = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset.y -= scrolling_speed * delta
