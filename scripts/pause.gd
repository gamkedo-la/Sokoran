extends Control

func _input(event):
	if event.is_action_pressed("menu_pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_home_pressed():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state


func _on_btn_title_pressed():
	Global.goto_scene("res://scenes/MenuScene.tscn")
	get_tree().paused = false


func _on_btn_resume_pressed():
	get_tree().paused = false
	visible = false
