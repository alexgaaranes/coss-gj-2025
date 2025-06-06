extends PathFollow2D

enum State { IDLE, WALK }

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var idle_timer: Timer = $IdleTimer
@onready var walk_timer: Timer = $WalkTimer 

@export var move_speed: float = 0.05
@export var loop_path: bool = true   # true if looping

@export_range(4, 6.0, 0.1) var min_idle_time: float = 5.0
@export_range(4, 6.0, 0.1) var max_idle_time: float = 5.0

@export_range(2, 2, 0.1) var min_walk_time: float = 2.0
@export_range(2, 6, 0.1) var max_walk_time: float = 4.0

var current_state: State
var last_global_position: Vector2

func _ready() -> void:
	last_global_position = global_position
	
	# connect the timer nodes
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	walk_timer.timeout.connect(_on_walk_timer_timeout)

	var initial_choice = randi() % 2
	if initial_choice == 0:
		print("idle")
		_change_state(State.IDLE)
	else:
		print("walking")
		_change_state(State.WALK)
	print("after it")

func _process(delta: float) -> void:
	var prev_global_position = global_position

	match current_state:
		State.IDLE:
			pass 

		State.WALK:
			progress_ratio += move_speed * delta

			# Handle path looping
			if loop_path:
				progress_ratio = fmod(progress_ratio, 1.0) 

			var current_movement = global_position - prev_global_position
			_update_walk_animation(current_movement)

	last_global_position = global_position 

func _change_state(new_state: State) -> void:
	# for some reason di nagana ito kapag aang initial choice ay State.IDLE
	# may na fuck up ata idk, nagana naman pag naka comment out ito HAHAHAH
	#if current_state == new_state:
		#return
	
	# stop the timer node
	idle_timer.stop()
	walk_timer.stop()

	current_state = new_state

	match current_state:
		State.IDLE:
			animated_sprite.play("idle")
			var idle_time = randf_range(min_idle_time, max_idle_time)
			idle_timer.set_wait_time(idle_time)
			idle_timer.start() 

		State.WALK:
			var walk_time = randf_range(min_walk_time, max_walk_time)
			walk_timer.set_wait_time(walk_time)
			walk_timer.start()

func _on_idle_timer_timeout() -> void:
	_change_state(State.WALK)

func _on_walk_timer_timeout() -> void:
	_change_state(State.IDLE)

func _update_walk_animation(movement: Vector2) -> void:
	if abs(movement.x) > 0.01:
		if movement.x < 0:
			animated_sprite.flip_h = true
		elif movement.x > 0:
			animated_sprite.flip_h = false

	if animated_sprite.animation != "walk":
		animated_sprite.play("walk")
