extends PopupPanel


func _input(event):
	if event.is_action_pressed("pause_menu"):
		hide()
		get_tree().paused = false


func _on_resume_pressed():
	hide()
	get_tree().paused = false


func _on_quit_pressed():
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
