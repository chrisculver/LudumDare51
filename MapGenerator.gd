extends Node2D

@export var tileMapPath: NodePath
@export var playerPath: NodePath

@onready var tileMap = get_node(tileMapPath)
@onready var player = get_node(playerPath)

var loadedChunks = []

func _process(_delta):
	tileMap.make_chunk(tileMap.local_to_map(player.position))

