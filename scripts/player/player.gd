extends Node2D

var speed := 200.0
var weight := 1.0

func _ready():
	pass

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed / weight
	if Input.is_action_pressed("move_right"):
		velocity.x += speed / weight
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed / weight
	
	position += velocity * delta 
