extends Node
# Global signal provider
# To avoid complex node accessing
signal has_failed_stealing_food
signal has_successfully_sharon
signal send_player_location
signal is_stealing_food
signal is_finished_stealing_food

signal is_overlapping_food
signal is_not_overlapping_food

signal shake_camera

func game_lost() -> void:
	emit_signal("game_lost_triggered")
	get_tree().paused = true
	
func del_timer() -> void: 
	emit_signal("close_timer")

# Global Audio Signals
signal play_sound
signal play_step

signal game_lost_triggered
signal close_timer
