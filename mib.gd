extends Area2D
class_name Mib

@onready var AnimPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func being_abducted(pos):
	monitoring=false
	# I may not want to animate the position, just move cow towards spaceship...
	
	AnimPlayer.play("Abducted")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Abducted":
		queue_free()
