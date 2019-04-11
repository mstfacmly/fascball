extends KinematicBody2D

export (float) var ACCEL = 2.0
export (float) var DEACCEL = 4.0
var accel = 0.0
export (float) var speed = 0.25
#var linear_vel = Vector2()
var mv_x = 0.0
var mv_y = 0.0
var lin_vel = Vector2()
#var BALL_VELOCITY = 2.0

#onready var sprite = $sprite
onready var ball = get_parent().get_node('ball')

func _input(ev):
	mv_x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	mv_y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	
	if Input.is_action_just_pressed('ui_accept'):
		kick()

func _physics_process(dt):
	player(dt)

func player(dt):
	var move = Vector2(ceil(mv_x), ceil(mv_y))
	lin_vel += move * speed
	
	if move.dot(lin_vel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	var angle = atan2(mv_x, mv_y)
	rotation = angle
	transform.rotated(rotation)
	
	lin_vel = lerp(lin_vel, move, accel * dt)
	
	move_and_slide(lin_vel * 50)

func kick():
#	get_parent().get_node('ball').linear_velocity = Vector2(mv_x,mv_y) * BALL_VELOCITY
#	print(get_parent().get_node('ball').applied_focrce)
	pass

func _ready():
	var pos = Vector2()
	pos.y = get_viewport().size.y * .6
	pos.x = get_viewport().size.x * .6
		
	position = pos