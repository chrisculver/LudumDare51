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
			%StatusLabel.text = "Ship capacity breached, engines failing..."
		

var maxCapacity: int = 20:
	get:
		return maxCapacity
	set(newMax):
		maxCapacity=newMax
		$UILayer/UI.set_max_capacity(maxCapacity)


var cowScene = preload("res://cow.tscn")
var mibScene = preload("res://mib.tscn")
var rockScene = preload("res://rocks.tscn")

var lastUpgradeSize = 0
var lastUpgradeSpeed = 0
var lastUpgradeCapacity = 0
var UpgradeSizeCosts = [
		{'cost': {'cows': 0, 'mibs': 1, 'dirt': 0}, 'multiplier': 0.1}, 
		{'cost': {'cows': 0, 'mibs': 3, 'dirt': 0}, 'multiplier': 0.1},
		{'cost': {'cows': 0, 'mibs': 5, 'dirt': 0}, 'multiplier': 0.1}, 
		{'cost': {'cows': 0, 'mibs': 7, 'dirt': 0}, 'multiplier': 0.1},
		{'cost': {'cows': 0, 'mibs': 9, 'dirt': 0}, 'multiplier': 0.15}, 
		{'cost': {'cows': 0, 'mibs': 11, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 0, 'mibs': 15, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 0, 'mibs': 19, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 0, 'mibs': 25, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 0, 'mibs': 35, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 0, 'mibs': 50, 'dirt': 3}, 'multiplier': 0.2},
	]

var UpgradeSpeedCosts = [
		{'cost': {'cows': 1, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15}, 
		{'cost': {'cows': 2, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15},
		{'cost': {'cows': 3, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15},
		{'cost': {'cows': 4, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15},
		{'cost': {'cows': 5, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15},
		{'cost': {'cows': 6, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15},
		{'cost': {'cows': 8, 'mibs': 0, 'dirt': 0}, 'multiplier': 0.15},
		{'cost': {'cows': 12, 'mibs': 0, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 20, 'mibs': 0, 'dirt': 3}, 'multiplier': 0.15},
		{'cost': {'cows': 30, 'mibs': 0, 'dirt': 3}, 'multiplier': 0.2},
		{'cost': {'cows': 40, 'mibs': 0, 'dirt': 3}, 'multiplier': 0.25},
		{'cost': {'cows': 50, 'mibs': 0, 'dirt': 5}, 'multiplier': 0.25},
		{'cost': {'cows': 60, 'mibs': 0, 'dirt': 5}, 'multiplier': 0.3},
]

var UpgradeCapacityCosts = [
	{'cost': {'cows': 1, 'mibs': 1, 'dirt': 1}, 'multiplier': 2}, 
	{'cost': {'cows': 3, 'mibs': 3, 'dirt': 3}, 'multiplier': 3},
	{'cost': {'cows': 10, 'mibs': 10, 'dirt': 5}, 'multiplier': 5},
	{'cost': {'cows': 50, 'mibs': 50, 'dirt': 10}, 'multiplier': 10.0}
]


# Called when the node enters the scene tree for the first time.
func _ready():
	#var overlay = load("res://debug_layer.tscn").instantiate()	
	#add_child(overlay)
	#debugOverlay = overlay
	$UILayer/UI.set_cows(cows)
	$UILayer/UI.set_dirt(dirtAmount)
	$UILayer/UI.set_current_capacity(currentCapacity)
	$UILayer/UI.set_max_capacity(maxCapacity)
	$UILayer/UI.set_mibs(mibs)

	#debugOverlay.add_stat("playerPos: ", $Player, "position", false)

	$UILayer/UpgradeMenu.set_next_speed_upgrade(UpgradeSpeedCosts[0]['cost']['cows'], 
		UpgradeSpeedCosts[0]['cost']['mibs'], UpgradeSpeedCosts[0]['cost']['dirt'])
		
	$UILayer/UpgradeMenu.set_next_size_upgrade(UpgradeSizeCosts[0]['cost']['cows'], 
		UpgradeSizeCosts[0]['cost']['mibs'], UpgradeSizeCosts[0]['cost']['dirt'])

	$UILayer/UpgradeMenu.set_next_capacity_upgrade(UpgradeCapacityCosts[0]['cost']['cows'], 
		UpgradeCapacityCosts[0]['cost']['mibs'], UpgradeCapacityCosts[0]['cost']['dirt'])

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
	
	if event.is_action_pressed("upgrade_menu") && not $Player.isBeamOn:
		#$Player.followMouse = not $Player.followMouse
		$UILayer/UpgradeMenu.visible = not $UILayer/UpgradeMenu.visible
		#$Camera2d.followMouse = not $Camera2D.followMouse


func _on_beam_timer_timeout():
	if $Player.isBeamOn:
		%StatusLabel.text = "Upgrade ship with [f]"
		$Player.turn_off_beam()
		$GetDirtTimer.stop()
	else:
		%StatusLabel.text = "Beam is on!"
		$UILayer/UpgradeMenu.visible = false
		$Player.turn_on_beam()
		$GetDirtTimer.start()


func _on_player_abducting_area(area):
	area.being_abducted($Player)
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
	add_child(mib)

func _on_get_dirt_timer_timeout():
	dirtAmount += 1
	currentCapacity+=1
	$GetDirtTimer.start()
	var rocks = rockScene.instantiate()
	rocks.position = $Player.position + $Player/MeshInstance2d.position
	add_child(rocks)
	rocks.being_abducted($Player)


func _on_upgrade_menu_upgrade_size():
	var upgrade = {'cost': {'cows': 10, 'mibs': 10, 'dirt': 5}}
	if lastUpgradeSize<len(UpgradeSizeCosts):
		upgrade = UpgradeSizeCosts[lastUpgradeSize]


	if (cows>=upgrade['cost']['cows']) and (mibs>=upgrade['cost']['mibs']) and (dirtAmount>=upgrade['cost']['dirt']):
		if not get_node("%UpgradeSizeProgress").visible:
			cows -= upgrade['cost']['cows']
			mibs -= upgrade['cost']['mibs']
			dirtAmount -= upgrade['cost']['dirt']
			currentCapacity -= (upgrade['cost']['cows']+upgrade['cost']['mibs']+upgrade['cost']['dirt'])

			$UpgradeSizeTimer.start()
			get_node("%UpgradeSizeProgress").visible = true

	else:
		$UILayer/UpgradeMenu.enable_button("%UpgradeSize")



func _on_upgrade_menu_upgrade_capacity():
	var upgrade = {'cost': {'cows': 10, 'mibs': 10, 'dirt': 5}}
	if lastUpgradeCapacity<len(UpgradeCapacityCosts):
		upgrade = UpgradeCapacityCosts[lastUpgradeCapacity]
		
	if lastUpgradeCapacity == len(UpgradeCapacityCosts)-1:
		%WinMenu.visible = true
		%UpgradeMenu.visible = false

	if (cows>=upgrade['cost']['cows']) and (mibs>=upgrade['cost']['mibs']) and (dirtAmount>=upgrade['cost']['dirt']):
		if not get_node("%UpgradeCapacityProgress").visible:
			cows -= upgrade['cost']['cows']
			mibs -= upgrade['cost']['mibs']
			dirtAmount -= upgrade['cost']['dirt']
			currentCapacity -= (upgrade['cost']['cows']+upgrade['cost']['mibs']+upgrade['cost']['dirt'])
	
		
			$UpgradeCapacityTimer.start()
			get_node("%UpgradeCapacityProgress").visible = true
	
	else:
		$UILayer/UpgradeMenu.enable_button("%UpgradeCapacity")




func _on_upgrade_menu_upgrade_speed():
	var upgrade = {'cost': {'cows': 10, 'mibs': 10, 'dirt': 5}}
	if lastUpgradeSpeed<len(UpgradeSpeedCosts):
		upgrade = UpgradeSpeedCosts[lastUpgradeSpeed]

	if (cows>=upgrade['cost']['cows']) and (mibs>=upgrade['cost']['mibs']) and (dirtAmount>=upgrade['cost']['dirt']):
		if not get_node("%UpgradeSpeedProgress").visible:
			cows -= upgrade['cost']['cows']
			mibs -= upgrade['cost']['mibs']
			dirtAmount -= upgrade['cost']['dirt']
			currentCapacity -= (upgrade['cost']['cows']+upgrade['cost']['mibs']+upgrade['cost']['dirt'])
	

			$UpgradeSpeedTimer.start()
			get_node("%UpgradeSpeedProgress").visible = true
	
	else:
		$UILayer/UpgradeMenu.enable_button("%UpgradeSpeed")


func _on_upgrade_menu_remove_debris():
	if not get_node("%RemoveDirtProgress").visible:
		$RemoveDirtTimer.start()
		get_node("%RemoveDirtProgress").visible = true



func _on_upgrade_speed_timer_timeout():
	var upgrade = UpgradeSpeedCosts[lastUpgradeSpeed]
	$Player.SPEED += $Player.SPEED*upgrade['multiplier']
	$Camera2d.step += $Camera2d.step*upgrade['multiplier']
	$UILayer/UpgradeMenu.enable_button("%UpgradeSpeed")
	get_node("%UpgradeSpeedProgress").visible = false
	get_node("%UpgradeSpeedProgress").value = 0
	
	if $GetDirtTimer.wait_time >= 0.2:
		$GetDirtTimer.wait_time -= 0.1
	
	lastUpgradeSpeed+=1
	if lastUpgradeSpeed < len(UpgradeSpeedCosts):
		$UILayer/UpgradeMenu.set_next_speed_upgrade(UpgradeSpeedCosts[lastUpgradeSpeed]['cost']['cows'], 
			UpgradeSpeedCosts[lastUpgradeSpeed]['cost']['mibs'], UpgradeSpeedCosts[lastUpgradeSpeed]['cost']['dirt'])
	else:
		$UILayer/UpgradeMenu.set_next_speed_upgrade(10,10,5)
	

func _on_upgrade_size_timer_timeout():
	var upgrade = UpgradeSizeCosts[lastUpgradeSize]
	
	$Player.SIZE += $Player.SIZE*upgrade['multiplier']
	$Player.SPEED += $Player.SPEED*upgrade['multiplier']
	$Camera2d.step += $Camera2d.step*upgrade['multiplier']
	if $GetDirtTimer.wait_time >= 0.2:
		$GetDirtTimer.wait_time -= 0.1

	$Camera2d.zoom = $Camera2d.zoom - $Camera2d.zoom*2.5*upgrade['multiplier']
	$UILayer/UpgradeMenu.enable_button("%UpgradeSize")
	get_node("%UpgradeSizeProgress").visible = false
	
	lastUpgradeSize+=1
	if lastUpgradeSize < len(UpgradeSizeCosts):
		$UILayer/UpgradeMenu.set_next_size_upgrade(UpgradeSizeCosts[lastUpgradeSize]['cost']['cows'], 
			UpgradeSizeCosts[lastUpgradeSize]['cost']['mibs'], UpgradeSizeCosts[lastUpgradeSize]['cost']['dirt'])
	else:
		$UILayer/UpgradeMenu.set_next_size_upgrade(10,10,5)
		


func _on_remove_dirt_timer_timeout():
	dirtAmount-=5
	currentCapacity-=5
	$UILayer/UpgradeMenu.enable_button("%RemoveDebris")
	get_node("%RemoveDirtProgress").visible = false


func _on_player_end_game():
	get_tree().paused = true
	$UILayer/RestartMenu.visible = true


func _on_upgrade_capacity_timer_timeout():
	var upgrade = UpgradeCapacityCosts[lastUpgradeCapacity]

	maxCapacity*=UpgradeCapacityCosts[lastUpgradeCapacity]['multiplier']
	lastUpgradeCapacity+=1
	
	if lastUpgradeCapacity < len(UpgradeCapacityCosts):
		$UILayer/UpgradeMenu.set_next_capacity_upgrade(UpgradeCapacityCosts[lastUpgradeCapacity]['cost']['cows'], 
			UpgradeCapacityCosts[lastUpgradeCapacity]['cost']['mibs'], UpgradeCapacityCosts[lastUpgradeCapacity]['cost']['dirt'])
	else:
		$UILayer/UpgradeMenu.set_next_capacity_upgrade(10,10,5)


	$UILayer/UpgradeMenu.enable_button("%UpgradeCapacity")
	get_node("%UpgradeCapacityProgress").visible = false





func win_game():
	print("You win!")





func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()


func _on_restart_win_menu_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
