extends 'res://scripts/entity.gd'

var react_time = 400.0
var ball_dist = 40

func _physics_process(dt):
	var pos = position
#	print(ball.position - pos)
	
	if abs(ball.position.x) > abs(pos.x) and abs(ball.position.x - pos.x) > ball_dist:
		pos.x -= ball.position.x
	if abs(ball.position.y) > abs(pos.y) and abs(ball.position.y - pos.y) > ball_dist:
		pos.y += -ball.position.y

	move_and_slide(-pos * 0.9)

func shoot():
	if !is_physics_processing():
		set_physics_process(0)
		
	print('shoot them!')

func goal():
	print('go to goal')

func _ready():
	add_to_group('facs')
	set_physics_process(0)
	
	position = ball.position - Vector2(ball_pos_calc, ball_pos_calc)