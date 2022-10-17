extends Node

signal moves_changed

var moves_left :int = 0 setget _set_moves_left
var moves_left_max: int = 6


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func emit_simple_signal_if_value_changed(signal_name, change_amount) -> void:
	if change_amount != 0:
		print_debug("Emitting ", signal_name)
		emit_signal(signal_name)


func _set_moves_left(val) -> void:
	var previous_val = moves_left
	moves_left = clamp(val, 0, moves_left_max)
	emit_simple_signal_if_value_changed("moves_changed", moves_left - previous_val)
	pass
