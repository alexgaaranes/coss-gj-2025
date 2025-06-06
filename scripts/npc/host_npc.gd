extends CharacterBody2D

enum State { IDLE, WALK, TURN }

var SPEED: float = 50.0
var MIN_DECISION_TIME: float = 0.5
var MAX_DECISION_TIME: float = 2.0

var direction: int = 1  # 1 = right, -1 = left
var current_state: State = State.IDLE

@onready var timer: Timer = get_node("Timer")
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	sprite.play("Idle")
	sprite.flip_h = direction < 0
	randomize()
	pick_random_behavior()

func _process(delta):
	match current_state:
		State.IDLE:
			sprite.play("Idle")
			velocity.x = 0
		State.WALK:
			sprite.play("Walk")
			velocity.x = direction * SPEED
		State.TURN:
			sprite.play("Idle")
			velocity.x = 0

	move_and_slide()

func pick_random_behavior():
	var choice = randi() % 3
	current_state = choice
	match current_state:
		State.IDLE:
			pass
		State.WALK:
			pass
		State.TURN:
			direction *= -1
			sprite.flip_h = direction < 0

	var wait_time = randf_range(MIN_DECISION_TIME, MAX_DECISION_TIME)
	timer.start(wait_time)

func _on_timer_timeout() -> void:
	pick_random_behavior()
	
