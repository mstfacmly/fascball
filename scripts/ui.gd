extends Node

#var start = 'UI Start'
signal sfx
onready var entity = get_tree().get_nodes_in_group('entity')
var timer

func _input(_ev):
	if !globals.game_on:
		if (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed('start')) && !$margin/menu.visible:
			emit_signal('sfx', globals.start_sfx)
			_blink_timer(.1)
			yield(get_tree().create_timer(1.2),"timeout")
			start_menu()
		if Input.is_action_just_pressed("ui_cancel") && $margin/menu.visible:
			title()
	else:
		if Input.is_action_just_pressed('ui_cancel'):
			pause()

func start_menu():
	$margin/menu.show()
	$margin/menu/start.grab_focus()
	timer.stop()
	timer.disconnect('timeout',self,'text_blink')
	$margin/title/start.hide()
	$margin/title/start_fill.show()

func connect_start_menu():
	$margin/menu/start.connect("pressed",self,'start')
	$margin/menu/opts.connect("pressed",self,'opts')
	$margin/menu/quit.connect("pressed",self,'quit')

func start():
	timer.connect('timeout',self,'text_blink',['margin/menu/start'])
	start_game()
	
func opts():
	print('options')

func quit():
	timer.connect('timeout',self,'text_blink',['margin/menu/quit'])
	_blink_timer(.1)
	emit_signal('sfx', globals.start_sfx)
	yield(get_tree().create_timer(2.1),"timeout")
	get_tree().quit()

func start_game():
	_blink_timer(.1)
	emit_signal('sfx', globals.start_sfx)
	yield(get_tree().create_timer(1.2),"timeout")
	globals.game_on = true
	globals.title.hide()
	globals.ui.show()
	$margin/menu.hide()
	$margin/menu/start.hide()
	$margin/menu/start_fill.show()
	for i in entity:
		i.show()
	$music.stop()
	timer.disconnect('timeout',self,'text_blink')

func pause():
	get_tree().paused = !get_tree().paused
	globals.center_txt.text = 'pause'
	globals.center_txt.visible = !globals.center_txt.visible
	emit_signal('sfx', globals.start_sfx)
	$margin/menu.set_visible(!$margin/menu.visible)
	if $margin/menu.visible:
		$margin/menu/opts.grab_focus()

func text_blink(text):
	get_node(text).set_visible(!get_node(text).visible)
	get_node(text+'_fill').set_visible(!get_node(text+'_fill').visible)

func _add_timer():
	timer = Timer.new()
	add_child(timer)

func _blink_timer(time):
	timer.start(time)

func title():
	timer.connect('timeout',self,'text_blink',['margin/title/start'])
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()
	$margin/menu.hide()
	_blink_timer(.5)

func _ready():
	$margin/title/info/ver.text = str(globals.version)
	# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	_add_timer()
	title()
	connect_start_menu()
