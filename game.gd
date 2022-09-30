extends Node3D

var debugOverlay = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://debug_layer.tscn").instantiate()	
	add_child(overlay)
	debugOverlay = overlay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("pause_menu"):
		$UILayer/PauseMenu.visible = true
		get_tree().paused = true
		#get_tree().get_root().set_input_as_handled()
