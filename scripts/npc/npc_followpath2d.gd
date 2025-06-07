extends PathFollow2D

enum State { IDLE, WALK, TSISMIS }

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_timer: Timer = $IdleTimer
@onready var walk_timer: Timer = $WalkTimer
@onready var tsismis_timer: Timer = $TsismisTimer 

@onready var dialogue_detection_area: Area2D = $CharacterBody2D/DialogueDetection
@onready var dialogue_text_label: Label = $CharacterBody2D/DialogueTextLabel
@onready var npc_dialogue = $CharacterBody2D/NpcDialogue/MarginContainer
@onready var npc_text = $CharacterBody2D/NpcDialogue/MarginContainer/MarginContainer/HBoxContainer/Label2

@export var npc_dialogue_text: String = "dialogue"

@export var move_speed: float = 0.05
@export var loop_path: bool = true # true if looping

@export_range(4, 6.0, 0.1) var min_idle_time: float = 5.0
@export_range(4, 6.0, 0.1) var max_idle_time: float = 5.0

@export_range(2, 6, 0.1) var min_walk_time: float = 2.0
@export_range(2, 6, 0.1) var max_walk_time: float = 4.0

# 3. Export variables for Tsismis duration
@export_range(3, 8.0, 0.1) var min_tsismis_time: float = 4.0
@export_range(3, 8.0, 0.1) var max_tsismis_time: float = 6.0

@export var player_dialogue_detection_group: String = "player_dialogue_detection_group"

var player_in_dialogue_area: bool = false

var current_state: State
var last_global_position: Vector2

func _ready() -> void:
	#randomize()
	last_global_position = global_position

	idle_timer.timeout.connect(_on_idle_timer_timeout)
	walk_timer.timeout.connect(_on_walk_timer_timeout)
	tsismis_timer.timeout.connect(_on_tsismis_timer_timeout)

	dialogue_detection_area.area_entered.connect(_on_dialogue_detection_area_entered)
	dialogue_detection_area.area_exited.connect(_on_dialogue_detection_area_exited)

	dialogue_text_label.text = npc_dialogue_text
	print("npc text: ", npc_text)
	npc_text.text = npc_dialogue_text
	npc_dialogue.visible = false

	var initial_choice = randi() % 3 
	if initial_choice == 0:
		print("initial state: idle")
		_change_state(State.IDLE)
	elif initial_choice == 1:
		print("initial state: walking")
		_change_state(State.WALK)
	else: 
		print("initial state: tsismis")
		_change_state(State.TSISMIS)
	print("after initial state setup")

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
		
		State.TSISMIS:
			pass

	last_global_position = global_position
	_update_dialogue_visibility()


func _change_state(new_state: State) -> void:
	idle_timer.stop()
	walk_timer.stop()
	tsismis_timer.stop() 

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
		
		State.TSISMIS:
			animated_sprite.play("tsismis")
			var tsismis_time = randf_range(min_tsismis_time, max_tsismis_time)
			tsismis_timer.set_wait_time(tsismis_time)
			tsismis_timer.start()


func _on_idle_timer_timeout() -> void:
	if randi() % 2 == 0: 
		_change_state(State.WALK)
	else: 
		_change_state(State.TSISMIS)

func _on_walk_timer_timeout() -> void:
	if randi() % 2 == 0: 
		_change_state(State.IDLE)
	else: 
		_change_state(State.TSISMIS)

func _on_tsismis_timer_timeout() -> void:
	if randi() % 2 == 0: 
		_change_state(State.IDLE)
	else: 
		_change_state(State.WALK)


func _update_walk_animation(movement: Vector2) -> void:
	if abs(movement.x) > 0.01:
		if movement.x < 0:
			animated_sprite.flip_h = true
		elif movement.x > 0:
			animated_sprite.flip_h = false

	if current_state == State.WALK and animated_sprite.animation != "walk":
		animated_sprite.play("walk")


func _update_dialogue_visibility() -> void:
	if player_in_dialogue_area and current_state == State.TSISMIS:
		npc_dialogue.visible = true
	else:
		npc_dialogue.visible = false


func _on_dialogue_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group(player_dialogue_detection_group):
		print("Player entered dialogue zone!")
		player_in_dialogue_area = true
		_update_dialogue_visibility()


func _on_dialogue_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group(player_dialogue_detection_group):
		print("Player exited dialogue zone!")
		player_in_dialogue_area = false
		_update_dialogue_visibility()
