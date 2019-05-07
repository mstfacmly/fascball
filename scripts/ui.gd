extends Node

#warning-ignore:unused_class_variable
var start = 'UI Start'
signal sfx
onready var entity = get_tree().get_nodes_in_group('entity')

#warning-ignore:unused_argument
func _input(ev):
	if Input.is_action_just_pressed('start'):
		if globals.game_on != true:
			start_game()
		else:
			pause()

func start_game():
	emit_signal('sfx', globals.start_sfx)
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
	emit_signal('sfx', globals.start_sfx)

func _ready():
#warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()