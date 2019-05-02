extends 'res://scripts/entity.gd'

#signal reset_fasc

enum states {ALIVE,DEAD}
var state = states.ALIVE
#warning-ignore:unused_class_variable
onready var fasc = get_tree().get_nodes_in_group('fasc')

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if Input.is_action_just_pressed('kick%s' % id):
		kick()
	elif Input.is_action_just_released('kick%s' % id):
		kick()

#warning-ignore:unused_argument
func _physics_process(dt):
	if state != states.DEAD: # == states.ALIVE:
		get_input()
	else:
		$collision.set_disabled(true)
		$area.set_monitoring(false)
		mv = Vector2(0,0)
		
#	post_goal(dt)

#func post_goal(dt):
#	if reload_time > 0:
#		reload_time -= dt
#
#		if reload_time <= 0:
#			emit_signal('reposition')
##			emit_signal('reset_fasc')
#			call_deferred('set_positions')
#			globals.center_txt.hide()
#			state = states.ALIVE
#			$collision.set_disabled(false)
#			$area.set_monitoring(true)
#			globals.dead_count = 0

func shot(body):
	if body.is_in_group('player') && body.state != states.DEAD:
		if id == body.id:
			state = states.DEAD
			globals.dead_count += 1
	
#	if globals.dead_count >= 2:
#		globals.center_txt.text = fasclines[randi() % fasclines.size()]
#		globals.f_score_count = globals.f_score_count + 1
#		on_goal()

func set_positions():
	if id == 0:
		position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
	if id == 1:
		position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
	look_at(ball.position)

	state = states.ALIVE
	$collision.set_disabled(false)
	$area.set_monitoring(true)

func _ready():
#	set_process(0)
	add_to_group('player')
	$chest.set_self_modulate(Color.green)
	set_positions()
#	for i in fasc:
#		print(i)
#		connect('reset_fasc', i, 'set_positions')
#		print(is_connected('reset_fasc', i,'set_positions'))