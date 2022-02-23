extends KinematicBody2D

#signal reposition
# warning-ignore:unused_signal
signal sfx

onready var ball = $'/root/field/ball'
export var id = 0
export (float) var ACCEL = 2.0
export (float) var DEACCEL = 4.0
var accel = 0.0
export (float) var speed = 0.1 #0.25
#var ball_pos = Vector2()
export var ball_pos_mod = 64
var ball_pos_calc = ball_pos_mod + (ball_pos_mod * 0.5)
#onready var ball_pos = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
var mv = Vector2()
var lin_vel = Vector2()
var BALL_VELOCITY = 2.0

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
	if mv:
		rotation = angle
	if mv.y:
		rotation = angle
#	rotation = transform.rotated(rotation)

	lin_vel = lerp(lin_vel, move, accel * dt)

	position += move_and_slide(lin_vel)
	rotation = rotation

func kick():
	$alive/leg.visible = !$alive/leg.visible
	
	if $kick.position.x == 0:
		$kick.position.x = 30
		$kick.collision_layer = 0
		$kick.collision_mask = 0
	else:
		$kick.position.x = 0
		$kick.collision_layer = 10
		$kick.collision_mask = 10

func stop():
	set_physics_process(0)

func hide_elements():
	$alive/leg.hide()
	$alive/gun.hide()
	$dead.hide()
	$kick.collision_layer = 10
	$kick.collision_mask = 10
	$kick.position.y = 0

func _ready():
	var chars = ['f','p']
	id = int(get_name().lstrip(chars))
	
	hide_elements()
	add_to_group('entity')
	
# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	
#	$chest.set_self_modulate(color)
