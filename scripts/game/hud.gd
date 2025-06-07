extends CanvasLayer

@onready var tupper_cont := $TupperContainer
@onready var timer_label := $Timer


@onready var game_over_panel := $GameOverPanel
@onready var game_win_panel := $GameWinPanel


@onready var restart_button_over := $GameOverPanel/ButtonContainer/RestartButton
@onready var menu_button_over := $GameOverPanel/ButtonContainer/ReturnButton
@onready var restart_button_win := $GameWinPanel/ButtonContainer/RestartButton
@onready var menu_button_win := $GameWinPanel/ButtonContainer/ReturnButton
@onready var food_overlap_hint_label := $FoodOverlapHint

@export var texture_empty: Texture2D
@export var texture_half: Texture2D
@export var texture_full: Texture2D

# Food overlap signal vars for hints
var isOverlappingFood: bool = false
var isStealing : bool = false

func _ready():
	GlobalSignals.connect("is_overlapping_food", self._on_overlap_food_show_hint)
	GlobalSignals.connect("is_not_overlapping_food", self._on_exit_overlap_food)
	GlobalSignals.connect("is_stealing_food", self._on_stealing_food)
	GlobalSignals.connect("is_finished_stealing_food", self._on_exit_stealing)
	GlobalSignals.connect("has_failed_stealing_food", self._on_exit_stealing)

func _process(delta):
	if isOverlappingFood:
		if isStealing:
			food_overlap_hint_label.text = "Press <ESC> to Stop"
		else:
			food_overlap_hint_label.text = "Press <Space> to Loot"
		food_overlap_hint_label.visible = true
	else:
		food_overlap_hint_label.visible = false

func update_timer_label(time_left: float) -> void:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_tupperwares(points: int, max_points: int, points_per: int) -> void:
	points = clamp(points, 0, max_points)
	var full_count = float(points) / points_per

	for i in range(tupper_cont.get_child_count()):
		var sprite = tupper_cont.get_child(i)
		if full_count >= i + 1:
			sprite.texture = texture_full
		elif full_count > i:
			sprite.texture = texture_half
		else:
			sprite.texture = texture_empty

func _on_overlap_food_show_hint():
	isOverlappingFood = true

func _on_exit_overlap_food():
	isOverlappingFood = false

func _on_stealing_food():
	isStealing = true

func _on_exit_stealing():
	isStealing = false

func show_game_over() -> void:
	game_over_panel.visible = true

func show_game_win() -> void:
	game_win_panel.visible = true

func hide_all_status_panels() -> void:
	game_over_panel.visible = false
	game_win_panel.visible = false
