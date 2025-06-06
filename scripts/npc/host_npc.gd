extends CharacterBody2D

enum State { IDLE, WALK, TURN, PURSUE, ANGRY }

@export var SPEED: float = 50.0
var MIN_DECISION_TIME: float = 0.5
var MAX_DECISION_TIME: float = 2.0

# Determines which direction facing
var direction: int = 1  # 1 = left, -1 = right

# What current action is bro performing
var current_state: State = State.IDLE

# Cooldown for randomized actions
@onready var timer: Timer = get_node("Timer")
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var playerDetector: Area2D = get_node("PlayerDetector")

# The position of the player when they fail the timing
var target_position: Vector2 = Vector2.ZERO

# Boolean switch logic
var angry_timer_started: bool = false

func _ready():
	GlobalSignals.connect("send_player_location", self._on_send_player_location)
	GlobalSignals.connect("is_stealing_food", self._on_is_stealing_food)

	sprite.play("Idle")
	sprite.flip_h = direction < 0
	randomize()
	pick_random_behavior()

func _process(delta):
	match current_state:
		State.ANGRY:
			velocity.x = 0
			sprite.play("Wait")
			if not angry_timer_started:
				timer.start(3)
				angry_timer_started = true
		State.PURSUE:
			sprite.play("Walk")
			
			# Go to place until you are there
			var dir = (target_position - position).normalized()
			velocity.x = dir.x * SPEED
			
			# Flip the dood
			direction = 1 if dir.x > 0 else -1
			sprite.flip_h = direction < 0
			
			# Bro is alr there, stop chasin
			if position.distance_to(target_position) < 150:
				print("I am done")
				velocity.x = 0
				sprite.play("Idle")
				current_state = State.IDLE
				timer.stop()
				timer.start(0.5)
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
	# Only up to the 3
	var choice = randi() % 3
	current_state = choice
	match current_state:
		State.IDLE:
			pass
		State.WALK:
			pass
		State.TURN:
			print("Facing " + ("Left" if direction == 1 else "Right"))
			direction *= -1
			sprite.flip_h = direction < 0
			
			# When turning, check if the newly turned
			# direction has the player
			var playerArea = get_player_in_detection_zone()
			if playerArea:
				evaluate_player_position(playerArea.position)
	
	var wait_time = randf_range(MIN_DECISION_TIME, MAX_DECISION_TIME)
	timer.start(wait_time)

# When timer gets timedout, reroll a new random action
# If not pursuing
func _on_timer_timeout() -> void:
	if current_state != State.PURSUE:
		pick_random_behavior()

# Checks if player is currently in vision
# Returns the Area2D of the player
func get_player_in_detection_zone() -> Area2D:
	var areas = playerDetector.get_overlapping_areas()
	for area in areas:
		if area.get_parent().name == "Player":
			return area
	return null

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().get_name() == "Player":
		evaluate_player_position(area.position)

# Boolean function to check if
# Player is in front or not
func evaluate_player_position(player_pos: Vector2) -> bool:
	var areaDirection := (player_pos - self.position).normalized()
	areaDirection.x = 1 if areaDirection.x > 0 else -1

	if areaDirection.x == direction:
		print("You are facing me")
		return true
	else:
		print("You are behind me")
		return false

# Listener for failed skill check signal
func _on_send_player_location(data):
	current_state = State.PURSUE;
	target_position = data
	print("Chasing!")

# Listener for skill check event
func _on_is_stealing_food():
	var isCaught = false
	var playerArea = get_player_in_detection_zone()
	if playerArea:
		isCaught = evaluate_player_position(playerArea.position)
		
	if isCaught:
		print("Caught ya!")
		current_state = State.ANGRY
