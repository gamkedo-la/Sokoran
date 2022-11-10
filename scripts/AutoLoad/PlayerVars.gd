extends Node

signal moves_changed
signal removes_changed
signal player_moved_tiles

var moves_left :int = 0 setget _set_moves_left
var moves_left_max: int = 100

var removes_changed :int = 0 setget _set_removes_changed
var removes_changed_max: int = 6

var cur_tile
var prev_tile
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func emit_simple_signal_if_value_changed(signal_name, change_amount) -> void:
	if change_amount != 0:
		print_debug("Emitting ", signal_name)
		emit_signal(signal_name)

func emit_simple_signal1_if_value_changed(signal_name1, change_amount1) -> void:
	if change_amount1 != 0:
		print_debug("Emitting1 ", signal_name1)
		emit_signal(signal_name1)

func _set_moves_left(val) -> void:
	var previous_val = moves_left
	moves_left = clamp(val, 0, moves_left_max)
	emit_simple_signal_if_value_changed("moves_changed", moves_left - previous_val)
	pass

func _set_removes_changed(val) -> void:
	var previous_val1 = removes_changed
	removes_changed = clamp(val, 0, removes_changed_max)
	emit_simple_signal1_if_value_changed("removes_changed", removes_changed - previous_val1)
	pass
