extends Node


export var max_load_time = 100000000
var show_bar = false
var show_bar_time = 100
var running_scene = null

var levels = [
	"res://scenes/LVLintro.tscn",
	"res://scenes/LVLone.tscn",
	"res://scenes/LVLone.tscn"
]

var loading_bar
var loading_bar_inst

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func goto_scene(path, current_scene):
	print_debug("Loading ", path, " and leaving ", current_scene)
	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print("Resource loaded unable to load the resource at path")
		return

		
	
	var t = OS.get_ticks_msec()
	
	while OS.get_ticks_msec() - t < max_load_time:
		if OS.get_ticks_msec() - t > show_bar_time && !show_bar:
			load_bar()
			show_bar = true
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			#Loading Complete
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred('add_child',resource.instance())
			
			current_scene.queue_free()
			if show_bar:
				loading_bar = null
				loading_bar_inst.queue_free()
				show_bar = false
			break
		elif err == OK:
			#Still loading
			if show_bar:
				var progress = float(loader.get_stage())/loader.get_stage_count()
				loading_bar.value = progress * 100
				print(progress)
		else:
			print("Error while loading file")
			break
		yield(get_tree(),"idle_frame")
		
func load_bar() -> void:
	loading_bar_inst = load("res://scenes/UI/LoadingBar.tscn").instance()
	
	get_tree().get_root().call_deferred('add_child',loading_bar_inst)
	loading_bar = loading_bar_inst.get_node_or_null("%ProgressBar")
	if loading_bar == null:
		print("Could not find loading bar scene.")
		return
