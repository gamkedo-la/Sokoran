extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect2/anim2.play("trans01")
	$planet/AnimationPlayer.play("1Action")
	$planet/AnimationPlayer2.play("2Action")
	$planet/AnimationPlayer3.play("3Action")
	$planet/AnimationPlayer4.play("4Action")
	$planet/AnimationPlayer5.play("Icosphere001Action")
	$planet/AnimationPlayer6.play("sputnikAction")
	$AnimationPlayer.play("text intro")
	$bg_song.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	Global.goto_scene(Global.levels[1])
	$ColorRect2/anim2.play("trans2")
	yield($ColorRect2/anim2,"animation_finished")
