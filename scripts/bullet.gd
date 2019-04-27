extends RigidBody2D

onready var players = get_tree().get_nodes_in_group('player')

func _ready():
	add_to_group('bullet')
	
	for p in players:
		$area.connect('body_entered', p, 'entered')
		
#	print('bullet connected ', is_connected('body_entered', players[0], 'entered'))