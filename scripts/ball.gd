extends Area2D

signal shoot
signal goal
signal reset

var ball_pos
var fasc
onready var ball = get_parent()

func entered(body):
#	print(body.get_groups())
	if body.is_in_group('player'):
		var id = body.id
		emit_signal('shoot', body, id)
	elif body.is_in_group('fasc'):
		var id = body.id
		emit_signal('goal', id )

#warning-ignore:unused_argument
func _physics_process(dt):
	fasc = get_tree().get_nodes_in_group('fasc')
	
	for i in fasc:
		if !is_connected('shoot', i , 'activate'):
			connections()
		else:
			pass

func connections():	
	for i in fasc:
		#warning-ignore:return_value_discarded
		connect('shoot', i , 'activate')
		#warning-ignore:return_value_discarded
		connect('goal', i , 'go_to_goal')
		connect('reset', i , 'set_positions')

func set_ball_position():
	ball_pos = get_viewport().get_size() * Vector2(0.52, 0.48) #.479
	ball.position = ball_pos
	emit_signal('reset')

func _ready():
	ball.add_to_group('ball')
	set_ball_position()
	connect('body_entered', self, 'entered')