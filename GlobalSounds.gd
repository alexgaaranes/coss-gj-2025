extends Node

@onready var click_sound = preload("res://assets/audio/click.wav")

func play_click():
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = click_sound
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
