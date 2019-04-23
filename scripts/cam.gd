extends Camera2D

var max_zoom = 1.0
var min_zoom = 0.7

var max_dist = 200
var min_dist = 100
onready var ball = get_parent().get_node('ball')
onready var player = get_parent().get_node('player')
#onready var player = get_tree().get_nodes_in_group('entity')

func _physics_process(dt):
	var target = ball.position
	var pos = player.position
	var delta = pos - target
	
	if abs(delta.x) > max_dist or abs(delta.y) > max_dist:
		if zoom < Vector2(max_zoom,max_zoom):
			zoom += zoom * dt
	elif abs(delta.x) < max_dist && abs(delta.x) > min_dist or abs(delta.y) <= max_dist && abs(delta.y) >= min_dist:
		if zoom > Vector2(min_zoom,min_zoom):
			zoom -= zoom * dt
	
#	print(zoom.x)
	
#	pos = target + delta
	
	position = target
	
func _ready():
	zoom = Vector2(min_zoom, min_zoom)