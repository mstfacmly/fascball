extends Area2D

signal out_of_bounds
#signal stop

var entity

func set_connections():
	entity = get_tree().get_nodes_in_group('entity')

# warning-ignore:return_value_discarded
	connect('body_entered', self, 'entered')
# warning-ignore:return_value_discarded
	connect('out_of_bounds', $'/root/field/ball' , 'out_of_bounds')

#	for i in entity:
#		connect('stop', i, 'stop')

func entered(body):
	if body.is_in_group('ball'):
		emit_signal('out_of_bounds', body)
#		emit_signal('stop')

func _ready():
	set_connections()
