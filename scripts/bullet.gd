#extends RigidBody2D
extends Node2D

onready var players = get_tree().get_nodes_in_group('player')
export var SPEED = 250
onready var velocity = Vector2(SPEED, 0).rotated(rotation)

func _init():
	add_to_group('bullet')

func _ready():
	connect( 'body_entered' , self, 'clear' )
	
	for p in players:
		connect( 'body_entered' , p , 'shot' )

func _process(dt):
	position = get_position() + velocity * dt
	
func clear(body):
	if body.is_in_group('player') || body.is_in_group('bounds') || body.is_in_group('goal'):
		disconnect( 'body_entered' , self , 'clear' )
		queue_free()
