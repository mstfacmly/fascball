extends Area2D

signal stop

var entity

func _physics_process(dt):
	entity = get_tree().get_nodes_in_group('entity')
	for i in entity:
		if !is_connected('stop', i, 'stop'):
			connections()
		else:
			pass

func entered(body):
	if body.is_in_group('goal'):
		for i in entity:
			emit_signal('stop')
			print('stop')

func connections():
	for i in entity:
		connect('stop', i, 'stop')
#		print(is_connected('stop',i,'stop'))


func _ready():
	add_to_group('goal')
	connect('body_entered', self, 'entered')
