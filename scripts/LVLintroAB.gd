extends Spatial

var water_height:= 1.5
var click_timer = 0.0
var mouse_ray_length = 10000 # Ray length for mouse input detection
var mouse_click_delay = 0.2 # Mouse up and down within this time will count as click
var z = 10  #
var tile_removed:= false

onready var plop_scene = preload("res://scenes/Plop.tscn")
onready var dice = preload("res://scenes/BlueDice.tscn")
onready var dice1 = preload("res://scenes/RedDice.tscn")

onready var meshlib = preload("res://resources/Tileset.tres")
# Blocks used for animating gridmap actions
var grass_block = preload("res://scenes/GridObjects/GrassBlock.tscn")
var obstacle_block = preload("res://scenes/GridObjects/Obstacle.tscn")
var grid_blocks = [
	grass_block,
	obstacle_block
	]

onready var camera = $Camera/Camera
onready var grid_map = get_node_or_null("%GridMap")
onready var ray_cast: RayCast = $Camera/Camera/RayCast
onready var indicator: Spatial = $Camera/Camera/Indicator

var ignore_controls = Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
var release_controls = Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

var roamer_anim = get_node_or_null("%roam_anim")

func _ready():
	if not PlayerVars.is_connected("player_moved_tiles", self, "_react_to_player_move"):
		var con_res = PlayerVars.connect("player_moved_tiles", self, "_react_to_player_move")
		assert(con_res == OK)
	
	#	$ColorRect.visible = true
#	$ColorRect/anim.play("to_zero")
	$Camera/Control/MeshInstance/AnimationPlayer.play("loop")
	$roam/roam_anim.play("roll")
	$Level/GridMap/randomasset/tree/AnimationPlayer.play("ArmatureAction")
	$Level/GridMap/randomasset/tree2/AnimationPlayer.play("ArmatureAction")
	$Player/pivot/planet/AnimationPlayer2.play("1Action")
	$Player/pivot/planet/AnimationPlayer3.play("2Action")
	$Player/pivot/planet/AnimationPlayer4.play("3Action")
	$Player/pivot/planet/AnimationPlayer5.play("4Action")
	$Player/pivot/planet/AnimationPlayer6.play("Icosphere001Action")
	$Player/pivot/planet/AnimationPlayer.play("sputnikAction")
	pass

func spawn_dice(position):
	if PlayerVars.removes_changed == 0:
		#blue dice
		var dice_inst = dice.instance()
		dice_inst.translation = position
		add_child(dice_inst)
		#red dice
		var dice1_inst = dice1.instance()
		dice1_inst.translation = position
		add_child(dice1_inst)
		
		PlayerVars.moves_left = 0
		PlayerVars.removes_changed = 0

	
func plop():
	var plop_inst = plop_scene.instance()
	plop_inst.position = get_viewport().get_mouse_position()
	add_child(plop_inst)
	

func _input(event):
	
	if event is InputEventMouseMotion:
		var hit = false
		var map_loc = mouse_to_grid()
		if grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z) == -1:
			map_loc.y -= 1
			if grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z) > -1:
				hit = true
		elif grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z) > -1:
			hit = true
		if indicator && hit:
			indicator.visible = true
			indicator.global_transform.origin = grid_map.map_to_world(map_loc.x, map_loc.y+1, map_loc.z)
		else:
			indicator.visible = false
	
	
	
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
			
	if  Input.is_action_just_pressed("mouse_right"):
		if PlayerVars.removes_changed > 0:
			var map_loc = mouse_to_grid()
			var player_loc = player_to_grid()
			print("mos"+str(map_loc))
			print("pl"+str(player_loc))
			if map_loc.x != player_loc.x or map_loc.z != player_loc.z: # Check to make sure we don't remove player's block
		#		print (map_loc)
		#		print (grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z))
				var spawn_block = false
				var cell_content = grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z)
				if cell_content == -1:
					map_loc.y -= 1
					cell_content = grid_map.get_cell_item(map_loc.x, map_loc.y, map_loc.z)
					if cell_content > -1:
						grid_map.set_cell_item(map_loc.x, map_loc.y, map_loc.z, -1)
						print(map_loc)
						spawn_block = true
				elif cell_content > -1:
					grid_map.set_cell_item(map_loc.x, map_loc.y, map_loc.z, -1)
					spawn_block = true
					
				if spawn_block && (cell_content < grid_blocks.size()):
					var temp_block = grid_blocks[cell_content].instance()
					add_child(temp_block)
					temp_block.global_transform.origin = grid_map.map_to_world(map_loc.x, map_loc.y, map_loc.z)
#					call_deferred("add_child", temp_block)
					
					var tween = get_tree().create_tween()
					tween.set_trans(Tween.TRANS_BOUNCE)			
					tween.tween_property(temp_block, "scale", Vector3.ZERO, 1.3).from_current()
					tween.tween_callback(temp_block, "queue_free").set_delay(2)
					PlayerVars.removes_changed -= 1
					
				if indicator:
					indicator.global_transform.origin = grid_map.map_to_world(map_loc.x, map_loc.y, map_loc.z)
			else:
				#skipped
				print("skipped")

func mouse_to_grid() -> Vector3:
	var ray_length = 1000
	var position2D = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(position2D)
	var to = from + camera.project_ray_normal(position2D) * ray_length
	var space_state = get_world().get_direct_space_state()		
	var result = space_state.intersect_ray(from, to)		
	if (result.size() > 0): # ray didnt intersect
		#print(result["position"])
		var map_loc = grid_map.world_to_map(result["position"])
		#print(map_loc)
		#print(player_to_grid())
		return map_loc
	else:
		return Vector3() # What should default be if no intersection?
		
func player_to_grid() -> Vector3:
	var player = get_node("Player") as StaticBody
	
	return grid_map.world_to_map(player.global_transform.origin)
	
func _process(_delta: float) -> void:
	$BackGround/Plane.translation.y = lerp($BackGround/Plane.translation.y, water_height,0.1)
	$BackGround/Plane2.translation.y = lerp($BackGround/Plane2.translation.y, water_height,0.1)
	$Camera/Camera.rotation_degrees.z = lerp($Camera/Camera.rotation_degrees.z, 0.0, 0.15)
	
#func _react_to_player_move() -> void:
#
#	var prev_tile_cord = grid_map.world_to_map(PlayerVars.cur_tile)
#	var cell_content = grid_map.get_cell_item(prev_tile_cord.x, prev_tile_cord.y-1, prev_tile_cord.z)
#	print("3d point", prev_tile_cord)
#	grid_map.set_cell_item(prev_tile_cord.x, prev_tile_cord.y-1, prev_tile_cord.z, -1)
#
#	var temp_block = grid_blocks[cell_content].instance()
#	add_child(temp_block)
#	temp_block.global_transform.origin = grid_map.map_to_world(prev_tile_cord.x, prev_tile_cord.y-1, prev_tile_cord.z)
#
##	call_deferred("add_child", temp_block)
#	var tween = get_tree().create_tween()
#	tween.set_trans(Tween.TRANS_BOUNCE)			
#	tween.tween_property(temp_block, "scale", Vector3.ZERO, 1.3).from_current()
#	tween.tween_callback(temp_block, "queue_free").set_delay(2)
#
func _on_Timer_timeout():
	randomize()
	water_height = rand_range(1,1.5)
	$Timer.wait_time = rand_range(0.1,0.6)
	
func shake()-> void: #camera shake when you go against a wall/unmoveable ob
	$Camera/Camera.rotation_degrees.z = -1
	
func _on_Timer2_timeout(): #enabling the mouse click by turning true ignore_controls
	ignore_controls=false
	


func _on_Timer3_timeout():
	$Label/AnimationPlayer.play("modulate")
	
