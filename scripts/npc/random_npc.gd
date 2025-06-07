extends Node2D

enum State { IDLE, WALK }

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_timer: Timer = $IdleTimer
@onready var walk_timer: Timer = $WalkTimer

@export var move_speed: float = 100.0 

@export_range(4, 6.0, 0.1) var min_idle_time: float = 5.0
@export_range(4, 6.0, 0.1) var max_idle_time: float = 5.0

@export_range(2, 6, 0.1) var min_walk_time: float = 2.0
@export_range(2, 6, 0.1) var max_walk_time: float = 4.0

var current_state: State
var walk_direction: int = 0 
func _ready() -> void:
	randomize()

	idle_timer.timeout.connect(_on_idle_timer_timeout)
	walk_timer.timeout.connect(_on_walk_timer_timeout)

	var initial_choice = randi() % 2
	if initial_choice == 0:
		_change_state(State.IDLE)
	else:
		_change_state(State.WALK)

func _process(delta: float) -> void:
	match current_state:
		State.IDLE:
			pass

		State.WALK:
			position.x += walk_direction * move_speed * delta  
			_update_walk_animation(walk_direction)

func _change_state(new_state: State) -> void:

	idle_timer.stop()
	walk_timer.stop()

	current_state = new_state

	match current_state:
		State.IDLE:
			animated_sprite.play("idle")
			walk_direction = 0
			var idle_time = randf_range(min_idle_time, max_idle_time)
			idle_timer.set_wait_time(idle_time)
			idle_timer.start()

		State.WALK:
			if randi() % 2 == 0:
				walk_direction = 1
			else:
				walk_direction = -1
			var walk_time = randf_range(min_walk_time, max_walk_time)
			walk_timer.set_wait_time(walk_time)
			walk_timer.start()

func _on_idle_timer_timeout() -> void:
	_change_state(State.WALK)

func _on_walk_timer_timeout() -> void:
	_change_state(State.IDLE)

func _update_walk_animation(direction: int) -> void:
	if direction != 0:
		if direction < 0: 
			animated_sprite.flip_h = true
		elif direction > 0:
			animated_sprite.flip_h = false

	if animated_sprite.animation != "walk":
		animated_sprite.play("walk")
