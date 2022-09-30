extends Control


func _input(event):
	if event.is_action_pressed("pause_menu"):
		visible=false
		get_tree().paused = false
		get_tree().get_root().set_input_as_handled()


func _on_resume_pressed():
	visible=false
	get_tree().paused = false


func _on_quit_pressed():
	visible=false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
