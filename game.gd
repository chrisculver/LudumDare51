extends Node2D

var debugOverlay = null
var points: int = 0:
	get: 
		return points
	set(newPoints): 
		points=newPoints
		$UILayer/UI.set_points(points)

var dirtAmount: int = 0:
	get:
		return dirtAmount
	set(newAmount):
		dirtAmount=newAmount
		if dirtAmount<0:
			dirtAmount=0
		$UILayer/UI.set_dirt(dirtAmount)

var cowScene = preload("res://cow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://debug_layer.tscn").instantiate()	
	add_child(overlay)
	debugOverlay = overlay
	$UILayer/UI.set_points(points)
	$UILayer/UI.set_dirt(dirtAmount)

	debugOverlay.add_stat("playerPos: ", $Player, "position", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tst = $TileMap.local_to_map($Player.position)
	pass

func _input(event):
	if event.is_action_pressed("pause_menu"):
		$UILayer/PauseMenu.visible = true
		get_tree().paused = true
		#get_tree().get_root().set_input_as_handled()

	if event.is_action_pressed("upgrade_menu"):
		$UILayer/UpgradeMenu.visible = not $UILayer/UpgradeMenu.visible

func _on_beam_timer_timeout():
	if $Player.isBeamOn:
		$Player.turn_off_beam()
		$GetDirtTimer.stop()
	else:
		$Player.turn_on_beam()
		$GetDirtTimer.start()


func _on_player_abducting_area(area):
	area.being_abducted($Player.position)
	points+=1
	$GetDirtTimer.stop()
	$GetDirtTimer.start()



func _on_tile_map_spawn_object(pos):
	var cow = cowScene.instantiate()
	cow.position = pos
	add_child(cow)

func _on_get_dirt_timer_timeout():
	dirtAmount += 1
	$GetDirtTimer.start()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()


func _on_upgrade_menu_upgrade_scale():
	$UpgradeSizeTimer.start()


func _on_upgrade_menu_upgrade_speed():
	$UpgradeSpeedTimer.start()


func _on_upgrade_menu_remove_dirt():
	$RemoveDirtTimer.start()



	






func _on_upgrade_speed_timer_timeout():
	$Player.SPEED += $Player.SPEED*0.1
	$Camera2d.step += $Camera2d.step*0.1

func _on_upgrade_size_timer_timeout():
	$Player.SIZE += $Player.SIZE*0.1
	$Camera2d.zoom -= $Camera2d.zoom*0.2

func _on_remove_dirt_timer_timeout():
	dirtAmount-=5
