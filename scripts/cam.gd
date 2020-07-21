extends Camera2D

var max_zoom = 1.0
var min_zoom = 0.7

var max_dist = 200
var min_dist = 100
onready var ball = get_tree().get_nodes_in_group('ball')[0]
onready var players = get_tree().get_nodes_in_group('entity')

func _process(dt):
	var player
	var delta = []
	
	initial_position(ball.position)

	for p in players:
		player = p.position
		delta.append(player - ball.position)
	delta = delta.min()

	zoom_camera(delta,dt)

func initial_position(target):
	position = Vector2(round(target.x * 0.81), round(target.y * 0.88))# + (target * 0.11)

func zoom_camera(delta,dt):
	if abs(delta.x) > max_dist or abs(delta.y) > max_dist:
		if zoom < Vector2(max_zoom,max_zoom):
			zoom += zoom * dt
	elif abs(delta.x) < max_dist && abs(delta.x) > min_dist or abs(delta.y) <= max_dist && abs(delta.y) >= min_dist:
		if zoom > Vector2(min_zoom,min_zoom):
			zoom -= zoom * dt
	else:
		zoom = Vector2(min_zoom, min_zoom)

func _ready():
	zoom = Vector2(min_zoom, min_zoom)
#	position = ball.position
