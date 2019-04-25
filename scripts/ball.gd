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
	if body.is_in_group('fasc'):
		var id = body.id
		emit_signal('goal', id )

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
		connect('shoot', i , 'activate')
		connect('goal', i , 'goal')
#		print(is_connected('shoot', fasc[0] , 'shoot'))

func _ready():
#	connections()
#	var pos = Vector2()
	connect('body_entered', self, 'entered')
#
	ball_pos = get_viewport().get_size() * Vector2(0.52, 0.48) #.479
	ball.position = ball_pos
#	position = ball_pos