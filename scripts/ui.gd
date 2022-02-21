extends Node

var start = 'UI Start'
signal sfx
onready var entity = get_tree().get_nodes_in_group('entity')
var timer

func _input(_ev):
	if Input.is_action_just_pressed('start'):
		if globals.game_on != true:
			start_game()
		else:
			pause()
	
	if Input.is_action_just_pressed("down0"):
		_blink_timer(.1)
	if Input.is_action_just_pressed("up0"):
		_blink_timer(.9)

func start_game():
	_blink_timer(.1)
	emit_signal('sfx', globals.start_sfx)
	yield(get_tree().create_timer(1.2),"timeout")
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

func text_blink():
	$margin/title/start.set_visible(!$margin/title/start.visible)
	$margin/title/sep2.set_visible(!$margin/title/sep2.visible)

func _add_timer():
	timer = Timer.new()
	add_child(timer)
	timer.connect('timeout',self,'text_blink')
	_blink_timer(.58)
	
func _blink_timer(time):
	timer.start(time)

func _ready():
	$margin/title/info/ver.text = str(globals.version)
	# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	_add_timer()
	
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()
