extends CanvasLayer

var stats = {}

func add_stat(stat_name, obj, stat_ref, is_method):
	stats[stat_name]=[obj, stat_ref, is_method]

func remove_stat(stat_name):
	stats.erase(stat_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var label_text = ""
	
	var fps = Engine.get_frames_per_second()
	var mem = OS.get_static_memory_usage()
	mem = String.humanize_size(mem)
	
	label_text += str("FPS: ", fps, "  StaticMem: ", mem)
	label_text += "\n" 

	for stat in stats:
		var s=stats[stat]
		var value = null 
		if s[0] and weakref(s[0]).get_ref():
			if s[2]:
				value = s[0].call(s[1])
			else:
				value = s[0].get(s[1])
		
		label_text += str(stat, ": ", value)
		label_text += "\n"
	$Label.text = label_text
