extends Camera2D

var max_dist = 300
var min_dist = 100
onready var ball = get_parent().get_node('ball')
onready var player = get_parent().get_node('player')

func _physics_process(dt):
	var target = ball.global_transform.origin
	var pos = player.global_transform.origin
	var delta = pos - target
	
	if abs(delta.x) > max_dist or abs(delta.y) > max_dist:
		if zoom < Vector2(2,2):
			zoom += Vector2(.01,.01)
	elif abs(delta.x) < max_dist && abs(delta.x) > min_dist or abs(delta.y) <= max_dist && abs(delta.y) >= min_dist:
		if zoom > Vector2(1,1):
			zoom -= Vector2(.01,.01)
	
	print(zoom.x)
	
	pos = target + delta
	
	position = target