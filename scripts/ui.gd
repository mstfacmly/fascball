extends Node

export var camera:NodePath

signal sfx
onready var entity = get_tree().get_nodes_in_group('entity')
var timer

func _ready():
	_set_version()
	_add_timer()
	
	_read_args()
	
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	$anims.connect("animation_finished", get_tree().get_nodes_in_group('camera')[0].get_child(0), '_on_anims_animation_finished')
	
	_show_warning()
	
	$margin/menu_opts/faspch/btn.set_pressed(1)
	
	fascpeech_toggle($margin/menu_opts/faspch/btn.pressed)
	ziospeech_toggle($margin/menu_opts/ziospch/btn.pressed)
	zioed_toggle($margin/menu_opts/zioed/btn.pressed)
	
	connect_start_menu()
	connect_options()
	
	$margin/ui/center/txt.rect_min_size.x = get_viewport().size.x * 0.75

func _unhandled_input(_ev):	
	if $warning.visible && (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed('start') || Input.is_action_just_pressed("ui_select")):
		_fade_warning()
		yield(get_tree().create_timer(1.0),"timeout")
	
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
		_zio_ed_logo_show($margin/menu_opts/zioed/btn.pressed)
	else:
		$margin/menu/opts.grab_focus()
	$margin/title/start.hide()
	$margin/title/start_fill.show()
	timer.stop()

func title():
	timer_connect('margin/title/start',.5)
	for i in entity:
		i.hide()
	globals.ui.hide()
	globals.center_txt.hide()
	$margin/menu.hide()
	$margin/menu_opts.hide()

func connect_start_menu():
	$margin/menu/start.connect("pressed",self,'start_game')
	$margin/menu/opts.connect("pressed",self,'options')
	$margin/menu/quit.connect("pressed",self,'quit')

func start_game():
	get_tree().get_nodes_in_group('ball')[0].call_deferred('fasc_ready',get_tree().get_nodes_in_group('fasc'))
	get_tree().get_nodes_in_group('goal')[0]._get_entities()
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
	
func connect_options():
	$margin/menu_opts/back.connect("pressed",self,'start_menu')
	$margin/menu_opts/fs/btn.connect("toggled",self, 'fullscreen')
	$margin/menu_opts/faspch/btn.connect("toggled",self,'fascpeech_toggle')
	$margin/menu_opts/ziospch/btn.connect("toggled",self,'ziospeech_toggle')
	$margin/menu_opts/zioed/btn.connect("toggled",self,'zioed_toggle')
	$anims.connect("animation_finished", self, 'zioslam')
	$anims.connect("animation_finished", self, '_set_theme')

func fullscreen(toggle):
	OS.set_window_fullscreen(toggle)

func fascpeech_toggle(toggle:bool):
	$margin/menu_opts/faspch/btn.set_text('On' if toggle == true else 'Off')
	if toggle:
		globals.read_fasclines('res://assets/fasclines.txt')
	else:
		globals.clear_fasclines('res://assets/fasclines.txt')

func ziospeech_toggle(toggle:bool):
	$margin/menu_opts/ziospch/btn.set_text('On' if toggle == true else 'Off')
	if toggle != false:
		globals.read_fasclines('res://assets/ziolines.txt')
	else:
		globals.clear_fasclines('res://assets/ziolines.txt')

func zioed(toggle:bool):
	$margin/menu_opts/zioed/btn.set_pressed(toggle)

func zioed_toggle(toggle:bool):
	# if I leave the if statements about fascspch, it gives an effect of gaslighting the player
	$margin/menu_opts/zioed/btn.set_text('On' if toggle == true else 'Off')
	ziospeech_toggle(toggle)
	fascpeech_toggle(!toggle)
	if toggle:
		$margin/ui/score/f.text = 'iof'
		$margin/ui/score/p.text = 'wrld'
		$margin/menu_opts/faspch/btn.set_pressed(0)
	else:
		$margin/ui/score/f.text = 'fa'
		$margin/ui/score/p.text = 'ntfa'
		$margin/menu_opts/faspch/btn.set_pressed(1)

func _zio_ed_logo_show(pressed:bool):
	if pressed && !$zioedlogo.visible:
		yield(get_tree().create_timer(0.48),"timeout")
		$anims.play("slam")
	elif !pressed && $zioedlogo.visible:
		$zioedlogo.hide()
		$anims.emit_signal("animation_finished", 'main')
#		_set_version()
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

func _set_theme(theme):
	if OS.is_debug_build():
		return
	
	match theme:
		'slam':
			$music.set_stream(globals.theme_zioed)
		'main':
			$music.set_stream(globals.theme)
	
	if $music.playing:
		return
	else:
		$music.play()

func _show_warning():
	$warning.show()
	$margin.hide()
	timer.connect('timeout',self,'_fade_warning')
	timer.start(10)
	
	return $warning.visible

func _fade_warning():
	if 	timer.is_connected('timeout',self,'_fade_warning'):
		timer.disconnect('timeout',self,'_fade_warning')
		
	if !$anims.is_connected("animation_finished", self, '_hide_warning'):
		$anims.connect("animation_finished", self, '_hide_warning')

	title()
	$anims.play("hide_warning")

func _hide_warning(_anim):
	$anims.disconnect("animation_finished", self, '_hide_warning')

	$margin.show()
	$warning.hide()
	
	_set_theme('main')

func _read_args():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
			call(key_value[0].lstrip('--'),bool(key_value[1]))
		else:
			arguments[argument.lstrip("--")] = ""

func _set_version():
	if $margin/menu_opts/zioed/btn.pressed:
		$margin/title/info/ver.text = str(globals.zio_ed_ver)
	else:
		$margin/title/info/ver.text = str(globals.version)
