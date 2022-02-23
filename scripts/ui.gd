extends Node

#var start = 'UI Start'
signal sfx
onready var entity = get_tree().get_nodes_in_group('entity')
var timer

func _input(_ev):
	if !globals.game_on:
		if (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed('start')) && !($margin/menu.visible || $margin/menu_opts.visible):
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
	$margin/menu_opts.hide()
	if !globals.game_on:
		$margin/menu/start.grab_focus()
	else:
		$margin/menu/opts.grab_focus()
	$margin/title/start.hide()
	$margin/title/start_fill.show()
	timer.stop()

func connect_start_menu():
# warning-ignore:return_value_discarded
	$margin/menu/start.connect("pressed",self,'start_game')
# warning-ignore:return_value_discarded
	$margin/menu/opts.connect("pressed",self,'options')
# warning-ignore:return_value_discarded
	$margin/menu/quit.connect("pressed",self,'quit')

func start_game():
	timer_connect('margin/menu/start',.1)
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
	timer.stop()
	$music.stop()

func options():
	$margin/menu.hide()
	$margin/menu_opts.show()
	$margin/menu_opts/faspch/btn.grab_focus()
	$margin/menu_opts/faspch/btn.set_text('On' if globals.fascpeech_toggle == true else 'Off')

func connect_options():
# warning-ignore:return_value_discarded
	$margin/menu_opts/back.connect("pressed",self,'start_menu')
# warning-ignore:return_value_discarded
	$margin/menu_opts/fs/btn.connect("toggled",self, 'fullscreen')
# warning-ignore:return_value_discarded
	$margin/menu_opts/faspch/btn.connect("toggled",self,'fascpeech_toggle')

func fullscreen(toggle):
	OS.set_window_fullscreen(toggle)

func fascpeech_toggle(toggle = true):
	globals.fascpeech_toggle = toggle
	$margin/menu_opts/faspch/btn.set_text('On' if toggle == true else 'Off')

func quit():
	timer_connect('margin/menu/quit',.1)
	emit_signal('sfx', globals.start_sfx)
	yield(get_tree().create_timer(2.1),"timeout")
	get_tree().quit()

func pause():
	get_tree().paused = !get_tree().paused
	globals.center_txt.text = 'pause'
	globals.center_txt.visible = !globals.center_txt.visible
	emit_signal('sfx', globals.start_sfx)
	$margin/menu.set_visible(get_tree().paused)
	if $margin/menu.visible:
		$margin/menu/opts.grab_focus()
	if $margin/menu_opts.visible && !get_tree().paused:
		$margin/menu_opts.hide()

func text_blink(text):
	get_node(text).set_visible(!get_node(text).visible)
	get_node(text+'_fill').set_visible(!get_node(text+'_fill').visible)

func _add_timer():
	timer = Timer.new()
	add_child(timer)

func timer_connect(text,timeout):
	if timer.is_connected('timeout',self,'text_blink'):
		timer.disconnect('timeout',self,'text_blink')
	timer.connect('timeout',self,'text_blink',[text])
	
	_blink_timer(timeout)

func _blink_timer(time):
	timer.start(time)

func title():
	timer_connect('margin/title/start',.5)
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()
	$margin/menu.hide()
	$margin/menu_opts.hide()

func _ready():
	$margin/title/info/ver.text = str(globals.version)
	# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	_add_timer()
	title()
	connect_start_menu()
	connect_options()
