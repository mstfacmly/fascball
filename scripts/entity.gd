extends KinematicBody2D

export (float) var ACCEL = 2.0
export (float) var DEACCEL = 4.0
var accel = 0.0
export (float) var speed = 0.25
#var ball_pos = Vector2()
export var ball_pos_mod = 64
var ball_pos_calc = ball_pos_mod + (ball_pos_mod * 0.5)
#onready var ball_pos = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
var mv = Vector2()
var lin_vel = Vector2()
#var BALL_VELOCITY = 2.0

onready var ball = get_parent().get_node('ball')
func _physics_process(dt):
	move(dt)

func move(dt):
	var move = Vector2(mv.x, mv.y)
	lin_vel += move * speed

	if move.dot(lin_vel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	var angle = atan2(mv.x, mv.y)
	rotation = lerp(rotation, angle, 2 * accel * dt)
#	rotation = transform.rotated(rotation)

	lin_vel = lerp(lin_vel, move, accel * dt)

	move_and_slide(lin_vel * 50)

func kick():
#	get_parent().get_node('ball').linear_velocity = Vector2(mv_x,mv_y) * BALL_VELOCITY
#	print(get_parent().get_node('ball').applied_focrce)
	pass
	
func _ready():
	$sprite.set_scale(Vector2(0.7,0.7))
	add_to_group('entity')