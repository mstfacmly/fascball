extends Node2D

signal stop
signal reposition
signal sfx
signal gen_field

var entity
export var id = 0
#var reload_time = 0
#export var RESP_TIME = 3

func _physics_process(dt):
	entity = get_tree().get_nodes_in_group('entity')
	for i in entity:
		if !$goal_area.is_connected('stop', i, 'stop'):
			connections()
		else:
			pass
	post_goal(dt)

func entered(body):
	if body.is_in_group('ball'):
		globals.center_txt.text = 'goal!'
		globals.center_txt.set_visible(true)
		
		if id == 1:
			globals.p_score_count = globals.p_score_count + 1 
		elif id == 0:
			globals.f_score_count = globals.f_score_count + 1
		
		on_goal()
		
		emit_signal('sfx', globals.score)
		
		for i in entity:
			emit_signal('stop')

func post_goal(dt):
	if globals.reload_time > 0:
		globals.reload_time -= dt
		
		if globals.reload_time <= 0:
			emit_signal('reposition')
			emit_signal('gen_field')
			globals.center_txt.hide()
			globals.dead_count = 0

func on_goal():
	globals.center_txt.show()
	globals.reload_time = globals.RESP_TIME

func connections():
	for i in entity:
		$goal_area.connect('stop', i, 'stop')
		connect('reposition', i, 'set_positions')
	connect('reposition', $'/root/field/ball' , 'set_ball_position')

func _ready():
	$goal_area.add_user_signal('stop')
	add_to_group('goal')

	$goal_area.connect('body_entered', self, 'entered')
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	connect('gen_field', $'/root/field', 'generate_field')
