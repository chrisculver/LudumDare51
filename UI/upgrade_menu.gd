extends Control

signal upgrade_size
signal upgrade_speed
signal upgrade_capacity
signal remove_debris

func enable_button(name):
	get_node(name).disabled=false




func set_next_speed_upgrade(cows, mibs, dirts):
	%UpgradeSpeedDisplay/HBoxContainer/Label.text = "x"+str(cows)
	%UpgradeSpeedDisplay/HBoxContainer2/Label.text = "x"+str(mibs)
	%UpgradeSpeedDisplay/HBoxContainer3/Label.text = "x"+str(dirts)

func set_next_size_upgrade(cows, mibs, dirts):
	%UpgradeSizeDisplay/HBoxContainer/Label.text = "x"+str(cows)
	%UpgradeSizeDisplay/HBoxContainer2/Label.text = "x"+str(mibs)
	%UpgradeSizeDisplay/HBoxContainer3/Label.text = "x"+str(dirts)

func set_next_capacity_upgrade(cows, mibs, dirts):
	%UpgradeCapacityDisplay/HBoxContainer/Label.text = "x"+str(cows)
	%UpgradeCapacityDisplay/HBoxContainer2/Label.text = "x"+str(mibs)
	%UpgradeCapacityDisplay/HBoxContainer3/Label.text = "x"+str(dirts)




func _on_upgrade_speed_pressed():
	get_node("%UpgradeSpeed").disabled=true
	emit_signal("upgrade_speed")


func _on_remove_debris_pressed():
	get_node("%RemoveDebris").disabled=true
	emit_signal("remove_debris")


func _on_upgrade_size_pressed():
	get_node("%UpgradeSize").disabled=true
	emit_signal("upgrade_size")


func _on_upgrade_capacity_pressed():
	get_node("%UpgradeCapacity").disabled=true
	emit_signal("upgrade_capacity")
