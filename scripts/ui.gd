extends Node

#warning-ignore:unused_argument
func _input(ev):
	if Input.is_action_just_pressed('start'):
		pause()

func pause():
	get_tree().paused = !get_tree().paused
	globals.center_txt.text = 'pause'
	globals.center_txt.visible = !globals.center_txt.visible

func _ready():
	globals.center_txt.hide()
