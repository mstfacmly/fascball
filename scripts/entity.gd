extends KinematicBody2D

onready var ball = $'/root/field/ball'

#warning-ignore:unused_class_variable
export var id = 0
export (float) var ACCEL = 2.0
export (float) var DEACCEL = 4.0
var accel = 0.0
export (float) var speed = 0.1 #0.25
#var ball_pos = Vector2()
export var ball_pos_mod = 64
#warning-ignore:unused_class_variable
var ball_pos_calc = ball_pos_mod + (ball_pos_mod * 0.5)
#onready var ball_pos = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
var mv = Vector2()
var lin_vel = Vector2()
var BALL_VELOCITY = 2.0
var reload_time = 0.0

var fasclines = [
'get along', 
'fair and balanced', 
'so much for the tolerant left',
'peace enforced'
]

#var pos_calc
#var rot_mod

#export var color = white

func _physics_process(dt):
	
	move(dt)

func move(dt):
	var move = Vector2(mv.x, mv.y)
	lin_vel += move * speed

	if move.dot(lin_vel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	var angle = atan2(mv.y, mv.x)
	if mv.x:
		rotation = lerp(deg2rad(rotation_degrees), angle, 2 * accel * dt)
	if mv.y:
		rotation = lerp(rotation, angle, 2 * accel * dt)
#	rotation = transform.rotated(rotation)

	lin_vel = lerp(lin_vel, move, accel * dt)

	position += move_and_slide(lin_vel)

func kick():
	$leg.show()
#	ball.set_linear_velocity(mv * BALL_VELOCITY)
#	get_parent().get_node('ball').linear_velocity = Vector2(mv_x,mv_y) * BALL_VELOCITY
#	print(get_parent().get_node('ball').applied_focrce)
	
func stop():
#	print('goal!')
	set_physics_process(0)
	
func reload():
	if reload_time <= 0.01:
		get_tree().reload_current_scene()
	else:
		reload_time -= globals.RESP_TIME - OS.get_ticks_msec()
	pass
func _ready():
	var chars = ['f','p']
	id = int(get_name().lstrip(chars))

	$leg.hide()
	$gun.hide()
#	$sprite.set_scale(Vector2(0.7,0.7))
	add_to_group('entity')
	
#	$chest.set_self_modulate(color)