extends Control


func _on_restart_pressed():
	visible=false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed():
	visible=false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
