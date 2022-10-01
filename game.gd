extends Node2D

var debugOverlay = null
var points: int = 0:
	get: 
		return points
	set(newPoints): 
		points=newPoints
		$UILayer/UI.set_points(points)

var cowScene = preload("res://cow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://debug_layer.tscn").instantiate()	
	add_child(overlay)
	debugOverlay = overlay
	$UILayer/UI.set_points(points)

	debugOverlay.add_stat("playerPos: ", $Player, "position", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tst = $TileMap.local_to_map($Player.position)
	#print(tst)
	#print(noise.get_noise_2d(tst.x, tst.y))
	pass

func _input(event):
	if event.is_action_pressed("pause_menu"):
		$UILayer/PauseMenu.visible = true
		get_tree().paused = true
		#get_tree().get_root().set_input_as_handled()


func _on_timer_timeout():
	if $Player.isBeamOn:
		$Player.turn_off_beam()
	else:
		$Player.turn_on_beam()


func _on_player_abducting_area(area):
	area.being_abducted($Player.position)
	points+=1


func _on_tile_map_spawn_object(pos):
	var cow = cowScene.instantiate()
	cow.position = pos
	add_child(cow)
	
