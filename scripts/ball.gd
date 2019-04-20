extends Area2D

signal shoot
signal goal

onready var fasc = $'/root/field/fasc'

func entered(body):
	print(body.get_groups())
	if body.is_in_group('player'):
		emit_signal('shoot')
	if body.is_in_group('fasc'):
		emit_signal('goal')


func _ready():
	connect('body_entered', self, 'entered')
	connect('shoot', fasc , 'shoot')
	connect('goal', fasc , 'goal')

#	var pos = Vector2()
#
#	pos.y = get_viewport().get_size().y * 0.5 #.479
#	pos.x = get_viewport().get_size().x * .5#2
#
#	position = pos