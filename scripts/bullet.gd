#extends RigidBody2D
extends Node2D

onready var players = get_tree().get_nodes_in_group('player')
export var SPEED = 250
onready var velocity = Vector2(SPEED, 0).rotated(rotation)

func _process(dt):
	position = get_position() + velocity * dt
	
func clear(body):
#	print(body.is_in_group('player'))
	if body.is_in_group('player') || body.is_in_group('bounds') || body.is_in_group('goal'):
		queue_free()

func _ready():
	add_to_group('bullet')
	connect('body_entered', self, 'clear')
	
	for p in players:
		connect('body_entered', p, 'shot')
#		print(is_connected('body_entered', p, 'shot'))
