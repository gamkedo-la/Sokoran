extends StaticBody

var dir: = Vector3.ZERO
var is_moving:= false

func _process(_delta:float)-> void:
	if dir!=Vector3.ZERO:
		movement(dir)
		


func set_dir(vec:Vector3)-> void:
	dir=vec

func movement(vec:Vector3) -> void:
	if is_moving == false:
		is_moving = true
		var a := translation
		var b := a + vec * 2
		$tw_m.interpolate_property(self, "translation", a, b, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$tw_m.start()
		yield($tw_m,"tween_all_completed")
		dir = Vector3.ZERO
		is_moving = false
	if $ray_down.is_colliding() == false :
		$AnimationPlayer.play("fall1")
		yield(get_tree().create_timer(1.5), "timeout")
		var _err = Global.goto_scene(Global.levels[Global.current_level])
		PlayerVars.moves_left = 0
		PlayerVars.removes_changed = 0
