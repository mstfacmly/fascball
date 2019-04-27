extends Area2D

signal shoot
signal goal

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
		
#	position = ball.position

func connections():	
	for i in fasc:
		#warning-ignore:return_value_discarded
		connect('shoot', i , 'activate')
		#warning-ignore:return_value_discarded
		connect('goal', i , 'go_to_goal')
#	print(is_connected('goal', fasc[0] , 'go_to_goal'))

func _ready():
	ball.add_to_group('ball')
#	connections()
#	var pos = Vector2()
	#warning-ignore:return_value_discarded
	connect('body_entered', self, 'entered')
#
	ball_pos = get_viewport().get_size() * Vector2(0.52, 0.48) #.479
	ball.position = ball_pos
#	position = ball_pos