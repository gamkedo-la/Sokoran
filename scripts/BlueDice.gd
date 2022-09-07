extends RigidBody
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
	$Timer.set_wait_time(5)
	$Timer.start()
	yield($Timer, "timeout")
	$AnimationPlayer.play("Death")
	yield($AnimationPlayer, "animation_finished")
	_on_Timer_timeout()
	
func _on_Timer_timeout():
	$Timer.connect("timeout", self, "queue_free")
