extends Spatial

var water_height:= 1.5
var click_timer = 0.0
var mouse_ray_length = 10000 # Ray length for mouse input detection
var mouse_click_delay = 0.2 # Mouse up and down within this time will count as click
var z = 10  #
onready var plop_scene = preload("res://scenes/Plop.tscn")
onready var dice = preload("res://scenes/BlueDice.tscn")
onready var camera = $Camera/Camera
onready var grid_map = get_node_or_null("%GridMap")
onready var ray_cast = $Camera/Camera/RayCast

var ignore_controls = Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
var release_controls = Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called when the node enters the scene tree for the first time.
func _ready():
#	$ColorRect.visible = true
#	$ColorRect/anim.play("to_zero")
	$Camera/Control/MeshInstance/AnimationPlayer.play("loop")
	pass

func spawn_dice(position):
	var dice_inst = dice.instance()
	dice_inst.translation = position
	add_child(dice_inst)
	
#	func despawn_dice():
#	$Timer2.connect("timeout", self, "queue_free")
#	$Timer2.set_wait_time(2)
#	$Timer2.start()
	
func plop():
	var plop_inst = plop_scene.instance()
	plop_inst.position = get_viewport().get_mouse_position()
	add_child(plop_inst)
	

func _input(_event):
	
	if !ignore_controls and !release_controls and Input.is_action_just_pressed("mouse_click"):
		click_timer = 0.1 # Reset the click timer
	if !ignore_controls and !release_controls and PlayerVars.moves_left == 0 and Input.is_action_just_released("mouse_click"):
		if click_timer < mouse_click_delay: # If within click delay threshold
			click_timer += mouse_click_delay
			var position2D = get_viewport().get_mouse_position()
			var dropPlane  = Plane(Vector3(0, 1, 0), z) 
			var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
			print(position3D)
			plop()
			spawn_dice(position3D)
#			PlayerVars.moves_left = 0
			ignore_controls = true #disable mouse and the start timer (next line) to ensable it again... all this so we can spawn one dice and wait until it disappear to throw a new on
			$Timer2.start()  #the next line timer
			
	if  Input.is_action_just_released("mouse_right"):
		
		var position2D = get_viewport().get_mouse_position()
		var dropPlane  = Plane(Vector3(0, 0, 1), z)
		var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
		print(position3D)
		var map_loc = grid_map.world_to_map(position3D)
		print (map_loc)
		print (grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z))
		ray_cast.cast_to = map_loc
		grid_map.set_cell_item(map_loc.x, map_loc.y, map_loc.z, -1)

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


func _on_Timer2_timeout(): #enabling the mouse click by turning true ignore_controls
	ignore_controls=false

