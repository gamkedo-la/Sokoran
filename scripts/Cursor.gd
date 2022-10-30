extends Node2D

var mouse_postion: Vector2
onready var viewport = get_viewport()

func _process(delta):
	mouse_postion = self.get_global_mouse_position()
	if mouse_postion.x < 0 or mouse_postion.y < 0 \
	 or mouse_postion.x > viewport.size.x or mouse_postion.y > viewport.size.y:
		# Cursor is outside game window
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.visible = false
	else:
		# Cursor is inside game window
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		self.visible = true
		self.position = mouse_postion
