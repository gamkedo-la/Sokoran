extends GridMap

var z = 10
onready var camera = $Camera/Camera

func _ready():
	print("gridmap")

func _process_process(_delta: float) -> void:
	
	if(Input.is_action_just_pressed("mouse_click")):
		print("remove")
		var position2D = get_viewport().get_mouse_position()
		var dropPlane  = Plane(Vector3(0, 1, 0), z)
		var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
		set_cell_item(position3D.x, position3D.y, position3D.z, -1)
		print("remove")
