extends Area

func _ready():
	$ColorRect.visible = true
	$ColorRect/anim2.play("trans01")
	
func _process(delta):
	# spin around
	var rot_speed = rad2deg(0.1)  # 30 deg/sec
	rotate_y(rot_speed * delta)

func _on_EndGoal_body_entered(body: Node) -> void:
	if body.is_in_group("box"):
		$ColorRect/anim2.play("trans2")
		yield($ColorRect/anim2,"animation_finished")
		Global.current_level += 1
		Global.goto_scene(Global.levels[Global.current_level])
