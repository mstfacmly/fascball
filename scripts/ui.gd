extends Node

onready var entity = get_tree().get_nodes_in_group('entity')

#warning-ignore:unused_argument
func _input(ev):
	if Input.is_action_just_pressed('start'):
		if globals.game_on != true:
			start_game()
		else:
			pause()

func start_game():
	globals.game_on = true
	globals.title.hide()
	globals.ui.show()
	for i in entity:
		i.show()
	$music.stop()

func pause():
	get_tree().paused = !get_tree().paused
	globals.center_txt.text = 'pause'
	globals.center_txt.visible = !globals.center_txt.visible

func _ready():
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()