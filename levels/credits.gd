extends Control

func _on_back_button_pressed():
	GlobalSounds.play_click()
	get_tree().change_scene_to_file("res://levels/menu.tscn")
