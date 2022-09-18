extends RigidBody


var prv_pos := Vector3.ZERO
var done_roll := false
var time_elapsed := 0.0
var roll_factor = 2

onready var face_rays: Spatial = get_node_or_null("%FaceRays")
onready var num_label: Label3D = $NumLabel

#randomize dice at spawn through axis/angular velocity
func _ready():
	#randomize dice throw
	randomize()
	var x = rand_range(-22,22)
	var y = rand_range(-22,22)
	var z = rand_range(-22,22)
	var a = rand_range(-2,2)
	var b = rand_range(-2,2)
	var c = rand_range(-2,2)
	set_angular_velocity(Vector3(x,y,z))
	set_axis_velocity(Vector3(a,b,c))
	
#	num_label.set_as_toplevel(true)
	num_label.scale = Vector3.ZERO
	num_label.visible = false
	#death animation stuff

#	yield($Timer, "timeout")
	
#	yield($AnimationPlayer, "animation_finished")

func _process(delta):
	time_elapsed += delta
	if time_elapsed > 0.1:
		time_elapsed = 0.0
		
		if (prv_pos == global_transform.origin) && !done_roll:
			done_roll = true
			$Timer.start()
			$Timer.set_wait_time(5)
			#determine dice roll
			_read_face()
		else:
			prv_pos = global_transform.origin 


func _read_face() -> void:
	var die_sides = face_rays.get_children()
	
	for side in die_sides:
		if side is RayCast:
			side.force_raycast_update()
			if side.is_colliding() && side.get_collision_normal().y > 0.5:
#				print_debug("Collision Normal: ", side.get_collision_normal())
				var roll_cnt = int(side.name)
				PlayerVars.moves_left += roll_cnt
				num_label.text = side.name
#				num_label.global_translation = global_translation
#				print_debug("You rolled: ", roll_cnt)
#				print_debug("2x roll: ", 2 * roll_cnt)
		pass
		
		
func _on_Timer_timeout():
	$AnimationPlayer.play("Death")
	
#	$Timer.connect("timeout", self, "queue_free")


func _on_BlueDice_body_entered(body):
	if abs(self.linear_velocity.x)>roll_factor or abs(self.linear_velocity.y)>roll_factor or abs(self.linear_velocity.z)>roll_factor:
		$AudioStreamPlayer.play()
#		AudioEffectDelay.feedback_delay_ms(600)
#		$AudioStreamPlayer.set_volume_db(5)


func _on_AudioStreamPlayer_finished():
	pass # Replace with function body.
