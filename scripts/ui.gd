extends Node

export var camera:NodePath

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
	_zio_ed_logo_show($margin/menu_opts/zioed/btn.pressed)
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
	get_tree().get_nodes_in_group('ball')[0].call_deferred('fasc_ready',get_tree().get_nodes_in_group('fasc'))
	timer_connect('margin/menu/start',.1)
	emit_signal('sfx', globals.start_sfx)
	yield(get_tree().create_timer(1.2),"timeout")
	globals.game_on = true
	globals.title.hide()
	globals.ui.show()
	$margin/menu.hide()
	$margin/menu/start.hide()
	$margin/menu/start_fill.show()
	$zioedlogo.hide()
	for i in entity:
		i.show()
	timer.stop()
	$music.stop()

func options():
	$margin/menu.hide()
	$margin/menu_opts.show()
	$margin/menu_opts/faspch/btn.grab_focus()
	fascpeech_toggle($margin/menu_opts/faspch/btn.pressed)
	ziospeech_toggle($margin/menu_opts/ziospch/btn.pressed)
	zio_ed($margin/menu_opts/zioed/btn.pressed)
	
func connect_options():
	$margin/menu_opts/back.connect("pressed",self,'start_menu')
	$margin/menu_opts/fs/btn.connect("toggled",self, 'fullscreen')
	$margin/menu_opts/faspch/btn.connect("toggled",self,'fascpeech_toggle')
	$margin/menu_opts/ziospch/btn.connect("toggled",self,'ziospeech_toggle')
	$margin/menu_opts/zioed/btn.connect("toggled",self,'zio_ed')
	$anims.connect("animation_finished", self, 'zioslam')
	$anims.connect("animation_finished", self, '_set_theme')

func fullscreen(toggle):
	OS.set_window_fullscreen(toggle)

func fascpeech_toggle(toggle:bool):
#	print('fasc spch ',toggle)
	$margin/menu_opts/faspch/btn.set_text('On' if toggle == true else 'Off')
	if toggle:
		globals.read_fasclines('res://assets/fasclines.txt')
	else:
		globals.clear_fasclines('res://assets/fasclines.txt')

func ziospeech_toggle(toggle:bool):
#	print('zio spch ',toggle)
	$margin/menu_opts/ziospch/btn.set_text('On' if toggle == true else 'Off')
	if toggle != false:
		globals.read_fasclines('res://assets/ziolines.txt')
	else:
		globals.clear_fasclines('res://assets/ziolines.txt')

func zio_ed(toggle:bool):
	$margin/menu_opts/zioed/btn.set_text('On' if toggle == true else 'Off')
	ziospeech_toggle(toggle)
	if toggle:
		$margin/ui/score/f.text = 'iof'
		$margin/ui/score/p.text = 'wrld'
		if $margin/menu_opts/faspch/btn.pressed:
			$margin/menu_opts/faspch/btn.set_pressed(0)
	else:
		$margin/ui/score/f.text = 'fa'
		$margin/ui/score/p.text = 'ntfa'

func _zio_ed_logo_show(pressed:bool):
	if pressed && !$zioedlogo.visible:
		yield(get_tree().create_timer(0.48),"timeout")
		$anims.play("slam")
	elif $zioedlogo.visible:
		$zioedlogo.hide()
		$anims.emit_signal("animation_finished", 'main')
		_set_version()
	else:
		return

func zioslam(arg):
	match arg:
		'slam':
			emit_signal("sfx", globals.expl)
			_set_version()

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
#	_zio_ed_logo_show($margin/menu_opts/zioed/btn.pressed)
	timer_connect('margin/title/start',.5)
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()
	$margin/menu.hide()
	$margin/menu_opts.hide()

func _set_theme(theme):
	match theme:
		'slam':
			$music.set_stream(globals.theme_zioed)
		'main':
			$music.set_stream(globals.theme)
	
	if $music.playing:
		return
	else:
		$music.play()

func _set_version():
	if $margin/menu_opts/zioed/btn.pressed:
		$margin/title/info/ver.text = str(globals.iof_ed_ver)
	else:
		$margin/title/info/ver.text = str(globals.version)

func _ready():
	_set_theme('main')
	_set_version()
	_add_timer()

	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	$anims.connect("animation_finished", get_tree().get_nodes_in_group('camera')[0].get_child(0), '_on_anims_animation_finished')

	$margin/menu_opts/faspch/btn.set_pressed_no_signal(1)
	
	title()
	connect_start_menu()
	connect_options()
