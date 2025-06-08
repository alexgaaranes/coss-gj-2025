extends Node

@onready var click_sound = preload("res://assets/audio/click.wav")
@onready var bgm_stream = preload("res://assets/audio/8bit-uing walang ningning.ogg")

var bgm_player: AudioStreamPlayer = null

func _ready():
	bgm_player = AudioStreamPlayer.new()
	bgm_player.stream = bgm_stream
	add_child(bgm_player)
	bgm_player.play()
	bgm_player.volume_db = -5

func play_click():
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = click_sound
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func play_bgm(audio_stream: AudioStream):
	bgm_player.stream = audio_stream
	bgm_player.play()

func stop_bgm():
	bgm_player.stop()
