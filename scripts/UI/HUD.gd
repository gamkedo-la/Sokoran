extends CanvasLayer


onready var moves_label = get_node_or_null("%MovesNum")
onready var move_cnt_sfx : AudioStreamPlayer = $MoveCount

var prev_moves: int = 0

var count_moves : int = 0
var count_time: float = 0.2
var time_elapsed: float = 0.0

var master_bus = AudioServer.get_bus_index("Master")
# Called when the node enters the scene tree for the first time.
func _ready():
	var check_label = is_instance_valid(moves_label)
	assert(check_label == true)
	if not PlayerVars.is_connected("moves_changed", self, "_update_moves"):
		var con_res = PlayerVars.connect("moves_changed", self, "_update_moves")
		assert(con_res == OK)
	prev_moves = PlayerVars.moves_left
	moves_label.text = str(PlayerVars.moves_left)
	pass # Replace with function body.


func _process(delta):	
	if count_moves > 0:
		time_elapsed += delta
		if time_elapsed > count_time:
			time_elapsed = 0.0
			count_moves -= 1
			moves_label.text = str(PlayerVars.moves_left - count_moves)
			move_cnt_sfx.play()


func _update_moves() -> void:
	count_moves = PlayerVars.moves_left - prev_moves
#	print_debug("count_moves: ", count_moves)
	prev_moves = PlayerVars.moves_left
#	print_debug("prev_moves: ", prev_moves)
	if count_moves < 0:
		moves_label.text = str(PlayerVars.moves_left)
		count_moves = 0 
	
	pass


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func _on_retry_pressed():
	var _err = get_tree().reload_current_scene()
