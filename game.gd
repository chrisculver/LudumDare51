extends Node3D

var playTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playTime += delta
	$UILayer/Timer/Clock.text = ("elapsed: %02d" % playTime) + "s"


func _input(event):
	if event.is_action_pressed("pause_menu"):
		$UILayer/PauseMenu.visible = true
		get_tree().paused = true
		#get_tree().get_root().set_input_as_handled()
