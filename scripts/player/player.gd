extends Node2D

@export var speed := 280.0
@export var weight := 1.0
@export var max_capacity := 100.0
@export var current_capacity := 1.0

var direction: int = 1  # 1 = right, -1 = left
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var camera: Camera2D = $Camera2D

var isStealing: bool = false
var velocity: Vector2

func _ready():
	sprite.play("Idle")
	camera.enabled = true
	GlobalSignals.connect("has_failed_stealing_food", self._on_has_failed_stealing_food)
	GlobalSignals.connect("is_stealing_food", self._on_is_stealing_food)
	GlobalSignals.connect("is_finished_stealing_food", self._on_is_finished_stealing_food)
	pass

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed / weight
		sprite.flip_h = true
		GlobalSignals.emit_signal("play_step")
	if Input.is_action_pressed("move_right"):
		velocity.x += speed / weight
		sprite.flip_h = false
		GlobalSignals.emit_signal("play_step")
		
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed / weight
	
	if velocity.x == 0:
		sprite.play("Idle")
	else:
		sprite.play("Walk")
	
	var hypo_position = position + (velocity * delta) 
	if hypo_position.x > 2528.0:
		position.x += 0
	else:
		if hypo_position.x < 64:
			position.x += 0
		else:
			position += velocity * delta 
	
func _on_has_failed_stealing_food():
	GlobalSignals.emit_signal("send_player_location", self.position)
	
func _on_is_stealing_food():
	isStealing = true
	
func _on_is_finished_stealing_food():
	isStealing = false

func add_food(capacity):
	current_capacity += capacity
	weight = 1 + (current_capacity / max_capacity / 2.5)
