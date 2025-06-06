extends Node2D

var speed := 200.0
var weight := 1.0

var direction: int = 1  # 1 = right, -1 = left
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	sprite.play("Idle")
	pass

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed / weight
		sprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		velocity.x += speed / weight
		sprite.flip_h = false
		
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed / weight
	
	if velocity.x == 0:
		sprite.play("Idle")
	else:
		sprite.play("Walk")
	
	position += velocity * delta 
