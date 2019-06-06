#extends RigidBody2D
extends Node2D

onready var players = get_tree().get_nodes_in_group('player')
onready var collider = $collision
export var SPEED = 250
onready var velocity = Vector2(SPEED, 0).rotated(rotation)

func _process(dt):
	position = get_position() + velocity * dt
	
func clear(body):
	if body.is_in_group('player') or body.is_in_group('bounds') or body.is_in_group('goal'):
		queue_free()

func _ready():
	add_to_group('bullet')
	$area.connect('body_entered', self, 'clear')
	
	for p in players:
		$area.connect('body_entered', p, 'shot')