extends Area2D

signal out_of_bounds

var entity

func _ready():
	set_connections()

func set_connections():
	entity = get_tree().get_nodes_in_group('entity')

	connect('body_entered', self, 'entered')
	connect('out_of_bounds', $'/root/field/ball' , 'out_of_bounds')

func entered(body):
	if body.is_in_group('ball'):
		emit_signal('out_of_bounds', body)
