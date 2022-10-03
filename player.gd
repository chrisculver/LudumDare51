extends Node2D

@export var SPEED: float = 250.0
@export var SIZE: float = 1.0:
	get:
		return SIZE
	set(newSize):
		SIZE=newSize
		scale=scale*SIZE
		$BeamParticles.get_process_material().scale_max=scale.x
		$BeamParticles.get_process_material().scale_min=scale.x

var isBeamOn: bool = true

signal abducting_area(area)
signal end_game

var lastDirection = Vector2(1,0)
var followMouse = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(0,0)
	if followMouse:
		direction = get_global_mouse_position() - position
		if abs(direction.x)<1 or abs(direction.y)<1:
			direction = Vector2(0,0)
	else:
		direction = lastDirection

	
	lastDirection=direction

	direction = direction.normalized()
	position += direction*SPEED*delta


func update_upgrade_progress(amount):
	$ProgressBar.value = amount


func turn_on_beam():
	isBeamOn = true
	$BeamParticles.emitting = true
	$BeamArea.monitoring = true
	
func turn_off_beam():
	isBeamOn = false
	$BeamParticles.emitting = false
	$BeamArea.monitoring = false


func _on_beam_area_area_entered(area):
	emit_signal("abducting_area", area)
	
func death():
	$AnimationPlayer.play("Death")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Death":
		emit_signal("end_game")
