extends Area2D

@onready var AnimPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func being_abducted(pos):
	monitoring=false
	# I may not want to animate the position, just move cow towards spaceship...
	var animation = AnimPlayer.get_animation("Abducted")
	animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(1, str(get_path())+":position")
	animation.track_insert_key(1,0,position)
	animation.track_insert_key(1,0.5,pos)
	
	AnimPlayer.play("Abducted")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Abducted":
		queue_free()
