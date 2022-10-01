extends Sprite2D

@export var SPEED: float = 250.0
@export var SIZE: float = 1.0:
	get:
		return SIZE
	set(newSize):
		SIZE=newSize
		scale=scale*SIZE
		$GpuParticles2d.get_process_material().scale_max=scale.x
		$GpuParticles2d.get_process_material().scale_min=scale.x

var isBeamOn: bool = true

signal abducting_area(area)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_global_mouse_position() - position

	if abs(direction.x)<1 or abs(direction.y)<1:
		direction = Vector2(0,0)

	direction = direction.normalized()
	position += direction*SPEED*delta



func turn_on_beam():
	isBeamOn = true
	$GpuParticles2d.emitting = true
	$BeamArea.monitoring = true
	
func turn_off_beam():
	isBeamOn = false
	$GpuParticles2d.emitting = false
	$BeamArea.monitoring = false


func _on_beam_area_area_entered(area):
	emit_signal("abducting_area", area)
