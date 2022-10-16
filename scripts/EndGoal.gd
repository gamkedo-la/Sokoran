extends Area

func _ready():
	$ColorRect.visible = true
	$ColorRect/anim.play("to_zero")
	
func _process(delta):
	# spin around
	var rot_speed = rad2deg(0.1)  # 30 deg/sec
	rotate_y(rot_speed * delta)

func _on_EndGoal_body_entered(body: Node) -> void:
	if body.is_in_group("box"):
		$ColorRect/anim.play("fade")
		yield($ColorRect/anim,"animation_finished")
		get_tree().change_scene("res://scenes/LVLone.tscn")
