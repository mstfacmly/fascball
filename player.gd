extends KinematicBody2D

export var ACCEL = 0.01
export var DEACCEL = 4.0
var speed = 1.0
var linear_vel = Vector2()
var mv_x = 0.0
var mv_y = 0.0
var lin_vel = Vector2()

onready var sprite = $sprite

func _input(ev):
	mv_x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	mv_y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')

func _physics_process(dt):
	player(dt)

func player(dt):
#	if mv_x:
	var move = Vector2(mv_x, mv_y)
	lin_vel += move
	
	if move.dot(lin_vel) > 0:
		speed = ACCEL
	else:
		speed = DEACCEL

	lin_vel = lin_vel.linear_interpolate(move, speed * dt)
	
	move_and_slide(lin_vel)
	
func _ready():
	var pos = get_viewport().size /2
	position = pos