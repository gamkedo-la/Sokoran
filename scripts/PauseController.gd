# The code is designed to use in a separate node of the type Node.
#   Nevertheless, it will not cause any conflict if more functionality is inside of the script file.
# For a working sound playing system, add an AudioStreamPlayer node as a
#   child of this PauseController and rename it to 'PauseSound'
 
extends Node
 
 
var can_toggle_pause: bool = true
 
export(AudioStream) var SOUND_PAUSE: AudioStream = null
export(AudioStream) var SOUND_RESUME: AudioStream = null
 
onready var pauseSound = $PauseSound
 
 
func _input(_delta):
	if can_toggle_pause and Input.is_action_just_pressed("menu_pause"):
		var tree_paused = get_tree().paused
		
		if !tree_paused:
			pause()
		else:
			resume()

 
func pause(play_sound: bool = true):
	if play_sound:
		pauseSound.stop()
		pauseSound.stream = SOUND_PAUSE
		pauseSound.play()
	get_tree().set_deferred("paused", true)
 
func resume(play_sound: bool = true):
	if play_sound:
		pauseSound.stop()
		pauseSound.stream = SOUND_RESUME
		pauseSound.play()
	get_tree().set_deferred("paused", false)
 
func trigger_damage_pause(pause_duration_ms: int = 10):
	pause(false)
	yield(get_tree().create_timer(pause_duration_ms * 0.001), "timeout")
	resume(false)
 
