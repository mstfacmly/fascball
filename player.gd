extends KinematicBody2D

export var ACCEL = 0.01
export var DEACCEL = 4.0
var accel = 0.0
var speed = 2.0
var linear_vel = Vector2()
var mv_x = 0.0
var mv_y = 0.0
var lin_vel = Vector2()

onready var sprite = $sprite

func _input(ev):
	mv_x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	mv_y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	
	if Input.is_action_just_pressed('ui_accept'):
		kick()

func _physics_process(dt):
	player(dt)

func player(dt):
#	if mv_x:
	var move = Vector2(speed * ceil(mv_x), speed * ceil(mv_y))
	lin_vel += move
	
	if move.dot(lin_vel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	lin_vel = lerp(lin_vel, move, accel * dt)
	
	move_and_slide(lin_vel)

func kick():
	
	pass

func _ready():
	var pos = Vector2()
	pos.y = get_viewport().size.y * .6
	pos.x = get_viewport().size.x * .6
		
	position = pos