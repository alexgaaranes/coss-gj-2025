extends CharacterBody2D

enum State { IDLE, WALK, TURN }

@export var SPEED: float = 50.0
var MIN_DECISION_TIME: float = 0.5
var MAX_DECISION_TIME: float = 2.0

var direction: int = 1  # 1 = left, -1 = right
var current_state: State = State.IDLE

@onready var timer: Timer = get_node("Timer")
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var playerDetector: Area2D = get_node("PlayerDetector")

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
			print("Facing " + ("Left" if direction == 1 else "Right"))
			direction *= -1
			sprite.flip_h = direction < 0
			
			var playerArea = get_player_in_detection_zone()
			if playerArea:
				evaluate_player_position(playerArea.position)

	var wait_time = randf_range(MIN_DECISION_TIME, MAX_DECISION_TIME)
	timer.start(wait_time)

func _on_timer_timeout() -> void:
	pick_random_behavior()
	
func get_player_in_detection_zone() -> Area2D:
	var areas = playerDetector.get_overlapping_areas()
	for area in areas:
		if area.get_parent().name == "Player":
			return area
	return null

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().get_name() == "Player":
		evaluate_player_position(area.position)
			
func evaluate_player_position(player_pos: Vector2) -> void:
	var areaDirection := (player_pos - self.position).normalized()
	areaDirection.x = 1 if areaDirection.x > 0 else -1

	if areaDirection.x == direction:
		print("You are facing me")
		
	else:
		print("You are behind me")
