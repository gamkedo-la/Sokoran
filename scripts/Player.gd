extends StaticBody

var dir: = Vector3.ZERO
var old_dir:= Vector3.ZERO
var is_moving:= false
var is_rotating:= false

var is_wall1 := false
var is_push1 := false
var is_wall2 := false
var is_push2 := false
var is_wall3 := false
var is_push3 := false

var rota_y := 0
var old_rota_Y := 0

#var player_moves := 2288

func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if PlayerVars.moves_left >= 1:
		_movelimit(delta)

func movement(vec:Vector3) -> void:
	if is_moving == false:
		is_moving = true
		var a := translation
		var b := a + vec * 2
		$tw_m.interpolate_property(self, "translation", a, b, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$tw_m.start()
		yield($tw_m,"tween_all_completed")
		if $ray_down.is_colliding() == false:
			var c= b + Vector3.DOWN * 2
			$AnimationPlayer.play("fall")
			$tw_m.interpolate_property(self, "translation", b, c, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
			$tw_m.start()
			yield(get_tree().create_timer(1.5), "timeout")
			var _err = get_tree().reload_current_scene()
		
		is_moving = false
		PlayerVars.moves_left -= 1
	
func _movelimit(_delta: float) -> void:
	dir = Vector3.ZERO
	if Input.is_action_just_pressed("ui_up"): dir = Vector3.BACK
	if Input.is_action_just_pressed("ui_down"): dir = Vector3.FORWARD
	if Input.is_action_just_pressed("ui_left"): dir = Vector3.RIGHT
	if Input.is_action_just_pressed("ui_right"): dir = Vector3.LEFT
	
	match dir:
		Vector3.BACK: rota_y = 0
		Vector3.FORWARD: rota_y = 180
		Vector3.RIGHT: rota_y = 90
		Vector3.LEFT: rota_y = -90
	
	if dir!=Vector3.ZERO and dir != old_dir:
		old_dir = dir
		$ray1.translation = old_dir * 2 + Vector3.UP * 2.5
		$ray2.translation = old_dir * 4 + Vector3.UP * 2.5
		$ray3.translation = old_dir * 6 + Vector3.UP * 2.5
		$ray1.force_raycast_update()
		$ray2.force_raycast_update()
		$ray3.force_raycast_update()
		
	if dir !=Vector3.ZERO:
		if $ray1.is_colliding():
			is_wall1 = $ray1.get_collider().is_in_group("wall")
			is_push1 = $ray1.get_collider().is_in_group("box")
		else:
			is_wall1 = false
			is_push1 = false
			
		if $ray2.is_colliding():
			is_wall2 = $ray2.get_collider().is_in_group("wall")
			is_push2 = $ray2.get_collider().is_in_group("box")
		else:
			is_wall2 = false
			is_push2 = false
			
		if $ray3.is_colliding():
			is_wall3 = true
		else:
			is_wall3 = false
			
		if is_wall1:
			get_parent().shake()
		elif is_push1 and is_wall2:
			get_parent().shake()
		elif is_push1 and is_push2 and is_wall3:
			get_parent().shake()
			
			
		elif not is_push1 and not is_wall1:
			movement(dir)
		elif is_push1 and not is_wall2 and not is_push2:
			$ray1.get_collider().set_dir(dir)
			movement(dir)
		elif is_push1 and is_push2 and not is_wall3:
			$ray1.get_collider().set_dir(dir)
			$ray2.get_collider().set_dir(dir)
			movement(dir)
			
	if rota_y != old_rota_Y and not is_rotating:
		is_rotating = true
		$tw_r.interpolate_property($body, 'rotation_degree:y', old_rota_Y, rota_y, 0.1,Tween.TRANS_EXPO, Tween.EASE_OUT)
		$tw_r.start()
		yield($tw_r, "tween_all_completed")
		old_rota_Y = rota_y
		is_rotating = false
		

