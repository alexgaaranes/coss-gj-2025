extends Control

func _ready():
	# play some music or some sht sa umpisa
	pass


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://levels/game_level.tscn")  # Change to your level scene path


func _on_quit_btn_pressed():
	get_tree().quit()
