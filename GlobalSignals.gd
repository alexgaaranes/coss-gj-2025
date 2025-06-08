extends Node
# Global signal provider
# To avoid complex node accessing
signal has_failed_stealing_food
signal has_successfully_sharon
signal send_player_location
signal is_stealing_food
signal is_finished_stealing_food
signal set_overlapping

signal is_overlapping_food
signal is_not_overlapping_food

signal shake_camera

# global function for game over for the host npc
func game_lost() -> void:
	emit_signal("game_lost_triggered")
	get_tree().paused = true
	
# delete timer indicator used by by host npc
func del_timer() -> void: 
	emit_signal("close_timer")

# Global Audio Signals
signal play_sound
signal play_step

# Global signals for game over and closing the timer indicator
signal game_lost_triggered
signal close_timer
