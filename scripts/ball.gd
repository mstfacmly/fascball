extends Area2D

signal shoot
signal goal

var ball_pos
onready var fasc = $'/root/field/fasc'
onready var ball = get_parent()

func entered(body):
#	print(body.get_groups())
	if body.is_in_group('player'):
		emit_signal('shoot')
	if body.is_in_group('fasc'):
		emit_signal('goal')

#func _physics_process(dt):
#	position = ball.position

func _ready():
	connect('body_entered', self, 'entered')
	connect('shoot', fasc , 'shoot')
	connect('goal', fasc , 'goal')

#	var pos = Vector2()
#
	ball_pos = get_viewport().get_size() * Vector2(0.52, 0.48) #.479
	ball.position = ball_pos
#	position = ball_pos