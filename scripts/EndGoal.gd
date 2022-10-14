extends Area

func _process(delta):
	# spin around
	var rot_speed = rad2deg(0.1)  # 30 deg/sec
	rotate_y(rot_speed * delta)

func _on_EndGoal_body_entered(body: Node) -> void:
	if body.is_in_group("box"):
		$Popup.popup()
