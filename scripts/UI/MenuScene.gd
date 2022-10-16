extends Spatial


var water_height:= 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta: float) -> void:
	$BackGround/Plane.translation.y = lerp($BackGround/Plane.translation.y, water_height,0.1)
	$BackGround/Plane2.translation.y = lerp($BackGround/Plane2.translation.y, water_height,0.1)
	$Camera/Camera.rotation_degrees.z = lerp($Camera/Camera.rotation_degrees.z, 0.0, 0.15)

	
func _on_Timer_timeout():
	randomize()
	water_height = rand_range(1,1.5)
	$Timer.wait_time = rand_range(0.1,0.6)



func shake()-> void: #camera shake when you go against a wall/unmoveable ob
	$Camera/Camera.rotation_degrees.z = -1


func _on_btn_new_pressed():
	var _err = get_tree().change_scene("res://scenes/LVLintro.tscn")


func _on_btn_quit_pressed():
	get_tree().quit()