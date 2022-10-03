extends Control

signal upgrade_scale
signal upgrade_speed
signal upgrade_storage
signal remove_dirt

func enable_button(name):
	get_node(name).disabled=false

func _on_upgrade_scale_pressed():
	emit_signal("upgrade_scale")
	get_node("%UpgradeScale").disabled=true

func _on_upgrade_speed_pressed():
	emit_signal("upgrade_speed")
	get_node("%UpgradeSpeed").disabled=true


func _on_remove_dirt_pressed():
	emit_signal("remove_dirt")
	get_node("%RemoveDirt").disabled=true


func _on_upgrade_storage_pressed():
	emit_signal("upgrade_storage")
	get_node("%UpgradeStorage").disabled=true
