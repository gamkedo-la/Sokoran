extends RigidBody


var prv_pos := Vector3.ZERO
var done_roll := false
var time_elapsed := 0.0
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
	#death animation stuff

#	yield($Timer, "timeout")
	
#	yield($AnimationPlayer, "animation_finished")

func _process(delta):
	time_elapsed += delta
	if time_elapsed > 0.5:
		time_elapsed = 0.0
		
		if (prv_pos == global_transform.origin) && !done_roll:
			done_roll = true
			$Timer.start()
			$Timer.set_wait_time(5)
			#determine dice roll
		else:
			prv_pos = global_transform.origin 
	
func _on_Timer_timeout():
	$AnimationPlayer.play("Death")
	
#	$Timer.connect("timeout", self, "queue_free")
	
