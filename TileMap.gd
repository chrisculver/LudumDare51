extends TileMap

@export var objectCut = 0.25 # [0.1 -> 0.2 people] # [0.2->0.3 minerals]
@export var objectProb = 0.04
@export var mibProb = 0.01
@export var chunkSize: int = 8

@onready var noise = FastNoiseLite.new()
@onready var rng = RandomNumberGenerator.new()

signal spawn_object
signal spawn_mib

func _ready():
	pass #make_chunk(0,0)

func make_chunk(position):
	var xStart = position.x
	var yStart = position.y
	for x in range(xStart-chunkSize,xStart+chunkSize):
		for y in range(yStart-chunkSize, yStart+chunkSize):
			if get_cell_source_id(0, Vector2i(x,y)) != -1:
				continue
			else:
				set_cell(0,Vector2i(x,y),0,Vector2i(0,0))
				var n = noise.get_noise_2d(x,y)
				#print(n)
				if abs(n)<objectCut and rng.randf()<objectProb:
					emit_signal("spawn_object", map_to_local(Vector2i(x,y)))
				elif rng.randf()<mibProb:
					emit_signal("spawn_mib", map_to_local(Vector2i(x,y)))
