extends Area2D

signal stop
var entity

#warning-ignore:unused_argument
func _physics_process(dt):
	entity = get_tree().get_nodes_in_group('entity')
	for i in entity:
		if !is_connected('stop', i, 'stop'):
			connections()
		else:
			pass

func entered(body):
	print(body.get_groups())
	if body.is_in_group('ball'):
		$'/root/field/ui/margin/align/center/txt'.text = 'goal!'
		$'/root/field/ui/margin/align/center/txt'.set_visible(true)

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