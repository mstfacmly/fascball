extends Area2D

signal stop
var entity
#warning-ignore:unused_class_variable
export var id = 0

#warning-ignore:unused_argument
func _physics_process(dt):
	entity = get_tree().get_nodes_in_group('entity')
	for i in entity:
		if !is_connected('stop', i, 'stop'):
			connections()
		else:
			pass

func entered(body):
#	print(body.get_groups())
	if globals.dead_count >= 2:
		pass
	elif body.is_in_group('ball'):
		globals.center_txt.text = 'goal!'
		globals.center_txt.set_visible(true)

		for i in entity:
			emit_signal('stop')

func connections():
	for i in entity:
#warning-ignore:return_value_discarded
		connect('stop', i, 'stop')

func _ready():
	add_to_group('goal')
#warning-ignore:return_value_discarded
	connect('body_entered', self, 'entered')