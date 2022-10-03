extends Area2D
class_name Cow

@onready var AnimPlayer = $AnimationPlayer

var player = null
var SPEED=3

# Called when the node enters the scene tree for the first time.
func being_abducted(play):
	monitoring=false
	AnimPlayer.play("Abducted")
	player = play
	
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Abducted":
		queue_free()


func _process(delta):
	if player:
		var direction = player.position - position
		position += SPEED*direction*delta
