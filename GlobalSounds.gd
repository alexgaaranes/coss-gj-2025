extends Node

@onready var click_sound = preload("res://assets/audio/click.wav")
@onready var bgm_stream = preload("res://assets/audio/8bit-uing walang ningning.ogg")
@onready var victory_music = preload("res://assets/audio/win.ogg")
@onready var lose_music = preload("res://assets/audio/lose.ogg")

var bgm_player: AudioStreamPlayer = null
var endscreen_player: AudioStreamPlayer = null

func _ready():
	bgm_player = AudioStreamPlayer.new()
	bgm_player.stream = bgm_stream
	add_child(bgm_player)
	bgm_player.play()
	bgm_player.volume_db = -5
	
	endscreen_player = AudioStreamPlayer.new()
	add_child(endscreen_player)
	endscreen_player.volume_db = -5
	endscreen_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	
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


func play_win_music():	

	bgm_player.stop() 
	endscreen_player.stream = victory_music
	endscreen_player.play()


func play_lose_music():
	bgm_player.stop()
	endscreen_player.stream = lose_music
	endscreen_player.play()

func on_restart_pressed():
	play_click()


func on_back_to_menu_pressed():
	play_click()
	play_bgm(bgm_stream)
