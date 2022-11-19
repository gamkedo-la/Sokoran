extends Area

var leaving = false

func _ready():
	$ColorRect.visible = true
	$ColorRect/anim2.play("trans01")
	$"black hole mesh/spin".play("spin")	
	$"black hole mesh/bhcore/AnimationPlayer".play("0Action001")
	$"black hole mesh/bhcore/AnimationPlayer".play("1Action001")
	$"black hole mesh/bhcore/AnimationPlayer".play("2Action001")
	$"black hole mesh/bhcore/AnimationPlayer".play("3Action001")
	$"black hole mesh/bhcore/AnimationPlayer".play("4Action001")
#func _process(delta):
#	# spin around
#	var rot_speed = rad2deg(0.1)  # 30 deg/sec
#	rotate_y(rot_speed * delta)

func _on_EndGoal_body_entered(body: Node) -> void:
	if body.is_in_group("box") && !leaving:
		leaving = true
		$ColorRect/anim2.play("trans2")
		yield($ColorRect/anim2,"animation_finished")
		Global.current_level += 1
		Global.goto_scene(Global.levels[Global.current_level])
