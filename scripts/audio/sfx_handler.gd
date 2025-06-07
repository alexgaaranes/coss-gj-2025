extends Node2D

func _ready():
	GlobalSignals.connect("play_sound", self._on_play_sound)
	GlobalSignals.connect("play_step", self._on_play_step)

func _on_play_sound(sound_name: String) -> void:
	get_node(sound_name).play()

func _on_play_step() -> void:
	if $Steps/StepSoundCD.is_stopped():
		var step_num = randi_range(1,3)
		$Steps.get_node("Step"+str(step_num)).play()
		$Steps/StepSoundCD.start()


func _on_step_sound_cd_timeout():
	$Steps/StepSoundCD.stop()
