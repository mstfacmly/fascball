extends Node2D

signal stop
signal reposition
signal sfx
signal clear_goal

var entity
var timer
export var id = 0
#var reload_time = 0
#export var RESP_TIME = 3

func _physics_process(_dt):
	entity = get_tree().get_nodes_in_group('entity')
	for i in entity:
		if !$goal_area.is_connected('stop', i, 'stop'):
			connections()
		else:
			pass

func entered(body):
	if body.is_in_group('ball'):
		globals.center_txt.text = 'goal!'
		globals.center_txt.set_visible(true)
		
		if id == 1:
			globals.p_score_count += 1 
		elif id == 0:
			globals.f_score_count += 1

		for i in entity:
			emit_signal('stop')
		
		on_goal()

func post_goal():
	emit_signal('reposition')
	emit_signal("clear_goal")
	globals.center_txt.hide()
	globals.dead_count = 0

func on_goal():
	globals.center_txt.show()
	emit_signal('sfx', globals.score)
#	timer.start(globals.RESP_TIME)
	yield(get_tree().create_timer(1.2),'timeout')
	post_goal()
#	globals.reload_time = globals.RESP_TIME

func connections():
	for i in entity:
# warning-ignore:return_value_discarded
		$goal_area.connect('stop', i, 'stop')
# warning-ignore:return_value_discarded
		connect('reposition', i, 'set_positions')
# warning-ignore:return_value_discarded
	connect('reposition', $'/root/field/ball' , 'set_ball_position')
# warning-ignore:return_value_discarded
	connect('clear_goal' , $'/root/field' , 'clear_goal' )

func _ready():
	$goal_area.add_user_signal('stop')
	add_to_group('goal')

# warning-ignore:return_value_discarded
	$goal_area.connect('body_entered', self, 'entered')
# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
