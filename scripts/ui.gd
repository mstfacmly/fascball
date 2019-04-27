extends Node

#warning-ignore:unused_argument
func _input(ev):
	if Input.is_action_just_pressed('start'):
		pause()

func pause():
	get_tree().paused = !get_tree().paused
	$margin/align/center/txt.text = 'pause'
	$margin/align/center/txt.visible = !$margin/align/center/txt.visible

func _ready():
	$margin/align/center/txt.hide()
