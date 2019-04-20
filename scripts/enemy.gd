extends 'res://scripts/entity.gd'

onready var ball = get_parent().get_node('ball')
var react_time = 400.0
var ball_dist = 40
var dir = 0
var vel = Vector2()

func _physics_process(dt):
	var pos = position
#	print(ball.position - pos)
	
	if abs(ball.position.x) > abs(pos.x) and abs(ball.position.x - pos.x) > ball_dist:
		pos.x -= ball.position.x
	if abs(ball.position.y) > abs(pos.y) and abs(ball.position.y - pos.y) > ball_dist:
		pos.y += -ball.position.y

	move_and_slide(-pos * 0.9)

func _ready():
	add_to_group('facs')
