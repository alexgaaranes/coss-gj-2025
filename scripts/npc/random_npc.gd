extends Node2D

enum State { IDLE, WALK }

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_timer: Timer = $IdleTimer
@onready var walk_timer: Timer = $WalkTimer

@export var move_speed: float = 100.0 # <--- Adjusted move speed for direct position control (pixels/second)
# @export var loop_path: bool = true # No longer relevant for random X movement, can remove this line

@export_range(4, 6.0, 0.1) var min_idle_time: float = 5.0
@export_range(4, 6.0, 0.1) var max_idle_time: float = 5.0

@export_range(2, 6, 0.1) var min_walk_time: float = 2.0
@export_range(2, 6, 0.1) var max_walk_time: float = 4.0

var current_state: State
var walk_direction: int = 0 # 1 for right, -1 for left
# last_global_position is no longer needed for movement calculation, but you could keep it for other uses if desired.
# For animation flipping, we'll just use the walk_direction.

func _ready() -> void:
	# Ensure random number generator is initialized (do this once in your main scene's _ready or project settings)
	randomize() # It's good practice to call randomize() here if you're not doing it globally

	# Connect the timer nodes
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	walk_timer.timeout.connect(_on_walk_timer_timeout)

	var initial_choice = randi() % 2
	if initial_choice == 0:
		print("Initial State: IDLE")
		_change_state(State.IDLE)
	else:
		print("Initial State: WALK")
		_change_state(State.WALK)
	print("after it")

func _process(delta: float) -> void:
	match current_state:
		State.IDLE:
			pass # No movement logic for IDLE state

		State.WALK:
			# Move the character horizontally
			position.x += walk_direction * move_speed * delta

			# You might want to add boundaries here to prevent the character from walking off-screen indefinitely
			# Example:
			# var screen_width = get_viewport_rect().size.x
			# if position.x < 0:
			#     position.x = 0
			#     # Optionally, reverse direction if hitting boundary
			#     walk_direction = 1
			# if position.x > screen_width:
			#     position.x = screen_width
			#     # Optionally, reverse direction if hitting boundary
			#     walk_direction = -1

			# Update animation based on current walk_direction
			_update_walk_animation(walk_direction)

# This function manages the state transitions.
func _change_state(new_state: State) -> void:
	# Your commented out line for `if current_state == new_state:` is generally correct behavior
	# It prevents re-entering the same state, which can restart timers unnecessarily.
	# It might have been causing issues if `current_state` wasn't initialized
	# before the first call, or if there was a tiny timing bug.
	# Let's re-enable it as it's good practice, assuming current_state is set correctly before the first call.
	#if current_state == new_state:
		#return

	# Stop any currently running timers before changing state
	idle_timer.stop()
	walk_timer.stop()

	current_state = new_state
	print("Changing to State: ", current_state) # For debugging

	match current_state:
		State.IDLE:
			animated_sprite.play("idle")
			# Clear walk_direction when idle
			walk_direction = 0
			var idle_time = randf_range(min_idle_time, max_idle_time)
			idle_timer.set_wait_time(idle_time)
			idle_timer.start()

		State.WALK:
			# Randomly choose initial walk direction (left or right)
			walk_direction = 1 if randi() % 2 == 0 else -1
			# The 'walk' animation playing and flipping is handled by _update_walk_animation in _process
			var walk_time = randf_range(min_walk_time, max_walk_time)
			walk_timer.set_wait_time(walk_time)
			walk_timer.start()

func _on_idle_timer_timeout() -> void:
	print("Idle Timer Timeout -> Changing to WALK")
	_change_state(State.WALK)

func _on_walk_timer_timeout() -> void:
	print("Walk Timer Timeout -> Changing to IDLE")
	_change_state(State.IDLE)

# This function now takes the walk_direction directly.
func _update_walk_animation(direction: int) -> void:
	# Only update flip if there's actual horizontal movement
	if direction != 0:
		if direction < 0: # Moving left
			animated_sprite.flip_h = true
		elif direction > 0: # Moving right
			animated_sprite.flip_h = false

	if animated_sprite.animation != "walk":
		animated_sprite.play("walk")
