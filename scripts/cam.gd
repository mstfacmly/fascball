extends Camera2D

var max_zoom = 1.4
var min_zoom = 0.7

var max_dist = 256
var min_dist = 128
onready var ball = get_tree().get_nodes_in_group('ball')[0]
onready var players = get_tree().get_nodes_in_group('player')

func _init():
	add_to_group('camera')

func _ready():
	zoom = Vector2(min_zoom, min_zoom)

func _process(dt):
	var delta = []
	
	_initial_position(ball.position)
	
	for player in players:
		delta.append(player.position.distance_to(ball.position))
	
#	for goal in get_tree().get_nodes_in_group('goal'):
#		delta.append(goal.position.distance_to(ball.position))
	
	_zoom(delta.min(),dt)

func _initial_position(target):
	position = Vector2(target.x, round(target.y * 0.95))# + (target * 0.11)

func _zoom(delta,dt):
	if delta > max_dist:
		if zoom.x < max_zoom:
			zoom += zoom * dt
	elif delta < max_dist && delta > min_dist:
		if zoom.x > min_zoom:
			zoom -= zoom * dt
