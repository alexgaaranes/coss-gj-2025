extends Node2D

func _on_area_2d_area_entered(area):
	if area.get_parent().get_name() == "Player":
		var timing_indicator_scene = preload("res://scenes/timing_indicator/timer.tscn")
		var timing_indicator = timing_indicator_scene.instantiate()
		get_parent().get_parent().add_child(timing_indicator)



func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().get_name() == "Player":
		get_parent().get_parent().get_node("Timer").queue_free()
