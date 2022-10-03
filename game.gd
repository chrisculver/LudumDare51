extends Node2D

var debugOverlay = null
var cows: int = 0:
	get: 
		return cows
	set(newcows): 
		cows=newcows
		$UILayer/UI.set_cows(cows)
		
var mibs: int = 0:
	get: 
		return mibs
	set(newmibs): 
		mibs=newmibs
		$UILayer/UI.set_mibs(mibs)

var dirtAmount: int = 0:
	get:
		return dirtAmount
	set(newAmount):
		dirtAmount=newAmount
		if dirtAmount<0:
			dirtAmount=0
		$UILayer/UI.set_dirt(dirtAmount)

var currentCapacity: int = 0:
	get:
		return currentCapacity
	set(amount):
		currentCapacity=amount
		$UILayer/UI.set_current_capacity(currentCapacity)
		if currentCapacity>maxCapacity:
			$Player.death()
		

var maxCapacity: int = 20:
	get:
		return maxCapacity
	set(newMax):
		maxCapacity=newMax
		$UILayer/UI.set_max_capacity(maxCapacity)
		if maxCapacity > 100:
			win_game()

var cowScene = preload("res://cow.tscn")
var mibScene = preload("res://mib.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://debug_layer.tscn").instantiate()	
	add_child(overlay)
	debugOverlay = overlay
	$UILayer/UI.set_cows(cows)
	$UILayer/UI.set_dirt(dirtAmount)
	$UILayer/UI.set_current_capacity(currentCapacity)
	$UILayer/UI.set_max_capacity(maxCapacity)
	$UILayer/UI.set_mibs(mibs)

	debugOverlay.add_stat("playerPos: ", $Player, "position", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tst = $TileMap.local_to_map($Player.position)
	if get_node("%UpgradeSpeedProgress").visible:
		get_node("%UpgradeSpeedProgress").value = (1.0-$UpgradeSpeedTimer.time_left/$UpgradeSpeedTimer.wait_time)*100
	if get_node("%UpgradeSizeProgress").visible:
		get_node("%UpgradeSizeProgress").value = (1.0-$UpgradeSizeTimer.time_left/$UpgradeSizeTimer.wait_time)*100
	if get_node("%UpgradeCapacityProgress").visible:
		get_node("%UpgradeCapacityProgress").value = (1.0-$UpgradeCapacityTimer.time_left/$UpgradeCapacityTimer.wait_time)*100
	if get_node("%RemoveDirtProgress").visible:
		get_node("%RemoveDirtProgress").value = (1.0-$RemoveDirtTimer.time_left/$RemoveDirtTimer.wait_time)*100





func _input(event):
	if event.is_action_pressed("pause_menu"):
		$UILayer/PauseMenu.visible = true
		get_tree().paused = true
		#get_tree().get_root().set_input_as_handled()

	if event.is_action_pressed("upgrade_menu"):
		#$Player.followMouse = not $Player.followMouse
		$UILayer/UpgradeMenu.visible = not $UILayer/UpgradeMenu.visible
		#$Camera2d.followMouse = not $Camera2D.followMouse

func _on_beam_timer_timeout():
	if $Player.isBeamOn:
		$Player.turn_off_beam()
		$GetDirtTimer.stop()
	else:
		$Player.turn_on_beam()
		$GetDirtTimer.start()


func _on_player_abducting_area(area):
	area.being_abducted($Player.position)
	currentCapacity+=1
	if area is Cow:
		cows+=1
	elif area is Mib:
		mibs+=1
	$GetDirtTimer.stop()
	$GetDirtTimer.start()



func _on_tile_map_spawn_object(pos):
	var cow = cowScene.instantiate()
	cow.position = pos
	add_child(cow)
	

func _on_tile_map_spawn_mib(pos):
	var mib = mibScene.instantiate()
	mib.position = pos
	print(mib, "   ", pos)
	add_child(mib)

func _on_get_dirt_timer_timeout():
	dirtAmount += 1
	currentCapacity+=1
	$GetDirtTimer.start()


func _on_upgrade_menu_upgrade_scale():
	if not get_node("%UpgradeSizeProgress").visible:
		$UpgradeSizeTimer.start()
		get_node("%UpgradeSizeProgress").visible = true

func _on_upgrade_menu_upgrade_storage():
	if not get_node("%UpgradeCapacityProgress").visible:
		$UpgradeCapacityTimer.start()
		get_node("%UpgradeCapacityProgress").visible = true

func _on_upgrade_menu_upgrade_speed():
	if not get_node("%UpgradeSpeedProgress").visible:
		$UpgradeSpeedTimer.start()
		get_node("%UpgradeSpeedProgress").visible = true


func _on_upgrade_menu_remove_dirt():
	if not get_node("%RemoveDirtProgress").visible:
		$RemoveDirtTimer.start()
		get_node("%RemoveDirtProgress").visible = true



func _on_upgrade_speed_timer_timeout():
	$Player.SPEED += $Player.SPEED*0.1
	$Camera2d.step += $Camera2d.step*0.1
	$UILayer/UpgradeMenu.enable_button("%UpgradeSpeed")
	get_node("%UpgradeSpeedProgress").visible = false
	get_node("%UpgradeSpeedProgress").value = 0

func _on_upgrade_size_timer_timeout():
	$Player.SIZE += $Player.SIZE*0.1
	$Camera2d.zoom -= $Camera2d.zoom*0.2
	$UILayer/UpgradeMenu.enable_button("%UpgradeScale")
	get_node("%UpgradeSizeProgress").visible = false

func _on_remove_dirt_timer_timeout():
	dirtAmount-=5
	currentCapacity-=5
	$UILayer/UpgradeMenu.enable_button("%RemoveDirt")
	get_node("%RemoveDirtProgress").visible = false


func _on_player_end_game():
	get_tree().paused = true
	$UILayer/RestartMenu.visible = true


func _on_upgrade_capacity_timer_timeout():
	maxCapacity*=2
	$UILayer/UpgradeMenu.enable_button("%UpgradeStorage")
	get_node("%UpgradeCapacityProgress").visible = false


func win_game():
	print("You win!")





func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()

