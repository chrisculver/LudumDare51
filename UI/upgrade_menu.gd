extends Control

signal upgrade_scale
signal upgrade_speed


func _on_upgrade_scale_pressed():
	emit_signal("upgrade_scale")


func _on_upgrade_speed_pressed():
	emit_signal("upgrade_speed")
