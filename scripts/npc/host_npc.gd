extends CharacterBody2D

enum State { IDLE, WALK, TURN, PURSUE, ANGRY }
enum Direction { LEFT = -1, RIGHT = 1 }

@export var SPEED: float = 150.0
var MIN_DECISION_TIME: float = 0.5
var MAX_DECISION_TIME: float = 2.0

# Determines which direction facing
# 1 = right, -1 = left

var direction: Direction = Direction.LEFT 

# What current action is bro performing
var current_state: State = State.IDLE

# Cooldown for randomized actions
@onready var timer: Timer = $Timer 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var playerDetector: Area2D = $PlayerDetector

var target_position: Vector2 = Vector2.ZERO

var angry_timer_started := false

func _ready():
	GlobalSignals.connect("send_player_location", self._on_send_player_location)
	GlobalSignals.connect("is_stealing_food", self._on_is_stealing_food)

	sprite.play("idle")

	sprite.flip_h = direction != Direction.LEFT
	randomize()
	
	timer.timeout.connect(self._on_timer_timeout_regular) 
	
	pick_random_behavior()

func _process(delta):
	match current_state:
		State.ANGRY:
			velocity.x = 0
			sprite.flip_h = direction != Direction.LEFT
			sprite.play("catch")
			if not angry_timer_started:
				timer.start(3)
				angry_timer_started = true
		State.PURSUE:
			sprite.play("walk")
			
			var dir = (target_position - position).normalized()
			velocity.x = dir.x * SPEED
			
			direction = Direction.RIGHT if dir.x > 0 else Direction.LEFT
			sprite.flip_h = direction == Direction.LEFT
			
			if position.distance_to(target_position) < 150:
				velocity.x = 0
				sprite.play("idle")

				sprite.flip_h = direction != Direction.LEFT

				current_state = State.IDLE
				timer.stop()
				timer.start(0.5) 
		State.IDLE:
			sprite.play("idle")
			sprite.flip_h = direction != Direction.LEFT
			velocity.x = 0
		State.WALK:
			sprite.play("walk")
			sprite.flip_h = direction == Direction.LEFT
			velocity.x = direction * SPEED
		State.TURN:
			sprite.play("idle")
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
			sprite.flip_h = direction != Direction.LEFT
			
			_on_is_stealing_food()
	
	var wait_time = randf_range(MIN_DECISION_TIME, MAX_DECISION_TIME)
	timer.start(wait_time)

func _on_timer_timeout_regular() -> void:
	# add if state is not angry
	angry_timer_started = false
	if current_state != State.PURSUE and current_state != State.ANGRY:
		pick_random_behavior()

func get_player_in_detection_zone() -> Area2D:
	var areas = playerDetector.get_overlapping_areas()
	for area in areas:
		if area.get_parent().name == "Player":
			return area
	return null

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().get_name() == "Player":
		# add the angry condition
		if current_state != State.ANGRY:
			_on_is_stealing_food()

func evaluate_player_position(player_pos: Vector2) -> bool:
	var areaDirection := (player_pos - self.position).normalized()
	areaDirection.x = 1 if areaDirection.x > 0 else -1
	
	print("Player at: ", player_pos.x)
	if areaDirection.x == direction:
		print("Front")
		return true
	else:
		print("Behind")
		return false

func _on_send_player_location(data):
	if current_state != State.ANGRY:
		current_state = State.PURSUE
		target_position = data

func _on_is_stealing_food():
	var isCaught = false
	var playerArea = get_player_in_detection_zone()

	if !playerArea:
		return
		
	var player = playerArea.get_parent()
	
	if !player:
		return
		
	if playerArea and player.isStealing:
		isCaught = evaluate_player_position(playerArea.get_parent().global_position)

	if isCaught:
		GlobalSignals.emit_signal("pan_camera", self.global_position)
		print("Passing to: ", self.global_position.x)
		GlobalSignals.del_timer()
		current_state = State.ANGRY 
		
		timer.stop()
		if timer.timeout.is_connected(self._on_timer_timeout_regular):
			timer.timeout.disconnect(self._on_timer_timeout_regular)
		
		# call the after angry animation
		timer.timeout.connect(self._on_angry_animation_finished_trigger_game_lost, CONNECT_ONE_SHOT)
		timer.start(3) # can change this idk 3 secs seems good

# calls this function to show the game over screen after the angry animation
func _on_angry_animation_finished_trigger_game_lost() -> void:
	GlobalSignals.game_lost()
	
	if not timer.timeout.is_connected(self._on_timer_timeout_regular):
		timer.timeout.connect(self._on_timer_timeout_regular)
