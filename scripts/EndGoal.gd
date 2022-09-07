extends Area

func _on_EndGoal_body_entered(body: Node) -> void:
	if body.is_in_group("box"):
		$Popup.popup()
