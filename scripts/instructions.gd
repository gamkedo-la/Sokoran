extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	var texture = $VBoxContainer/HBoxContainer7/ViewportContainer/Viewport.get_texture()	
#	$VBoxContainer/HBoxContainer7/TextureRect.texture = texture


func _on_h2p_pressed():
	Global.goto_scene("res://scenes/MenuScene.tscn")


func _on_h2p_mouse_entered():
	$h2p/ui_sound.play(0.0) # Replace with function body.


func _on_h2p_mouse_exited():
	$h2p/ui_sound.play(0.0)
