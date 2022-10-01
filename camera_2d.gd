extends Camera2D

@export var threshold: int = 150
@export var step: int = 4
@onready var viewport_size = get_viewport().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport = get_viewport()
	viewport_size = viewport.size
	var mouse_pos = viewport.get_mouse_position()
	
	var direction = Vector2(0,0)
	if mouse_pos.x < threshold:
		direction.x -= 1
	if mouse_pos.x > viewport_size.x - threshold:
		direction.x += 1
		
	if mouse_pos.y < threshold:
		direction.y -= 1
	if mouse_pos.y > viewport_size.y - threshold:
		direction.y += 1
	
	position += direction.normalized()*step
