extends CanvasLayer

onready var moves_label = get_node_or_null("%MovesNum")
onready var moves_label1 = get_node_or_null("%MovesNum1")
onready var move_cnt_sfx : AudioStreamPlayer = $MoveCount

var count_moves : int = 0
var prev_moves: int = 0

var count_removes : int = 0
var prev_removes : int = 0

var count_time: float = 0.2
var time_elapsed: float = 0.0

var master_bus = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	var check_label = is_instance_valid(moves_label)
	var check_label1 = is_instance_valid(moves_label1)
	assert(check_label == true)
	assert(check_label1 == true)
	
	#blue
	if not PlayerVars.is_connected("moves_changed", self, "_update_moves"):
		var con_res = PlayerVars.connect("moves_changed", self, "_update_moves")
		assert(con_res == OK)
		
	if not PlayerVars.is_connected("removes_changed", self, "_update_removes"):
		var con_res1 = PlayerVars.connect("removes_changed", self, "_update_removes")
		assert(con_res1 == OK)
		
#	#red
#	if not PlayerVars.is_connected("moves_changed", self, "_update_moves"):
#		var con_res1 = PlayerVars.connect("moves_changed", self, "_update_moves")
#		assert(con_res1 == OK)
#
#	if not PlayerVars.is_connected("removes_changed", self, "_update_removes"):
#		var con_res1 = PlayerVars.connect("removes_changed", self, "_update_removes")
#		assert(con_res1 == OK)
		
	prev_moves = PlayerVars.moves_left
	moves_label.text = str(PlayerVars.moves_left)
	
	prev_removes = PlayerVars.removes_changed
	moves_label1.text = str(PlayerVars.removes_changed)
	
	pass # Replace with function body.


func _process(delta):	
	if count_moves > 0:
		time_elapsed += delta
		if time_elapsed > count_time:
			time_elapsed = 0.0
			count_moves -= 1
			moves_label.text = str(PlayerVars.moves_left - count_moves)
			move_cnt_sfx.play()

	if count_removes > 0:
		time_elapsed += delta
		if time_elapsed > count_time:
			time_elapsed = 0.0
			count_removes -= 1
			moves_label1.text = str(PlayerVars.removes_changed - count_removes)
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

func _update_removes() -> void:
	count_removes = PlayerVars.removes_changed - prev_removes
	prev_removes = PlayerVars.removes_changed 
	
	if count_removes < 0:
		moves_label1.text = str(PlayerVars.removes_changed)
		count_removes = 0 
		
func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func _on_retry_pressed():
	PlayerVars.moves_left = 0
	PlayerVars.removes_changed = 0
	var _err = Global.goto_scene(Global.levels[Global.current_level])
	

func _on_btn_resume_mouse_entered():
	$ui_sound.play(0.0)


func _on_btn_title_mouse_entered():
	$ui_sound.play(0.0)
