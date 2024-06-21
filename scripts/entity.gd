extends KinematicBody2D

#signal reposition
# warning-ignore:unused_signal
signal sfx

enum states {alive,dead}
var state = states.alive setget set_state , get_state

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

export var can_kick = false setget set_can_kick , get_can_kick

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

	lin_vel = lerp(lin_vel, move, accel * dt)

	position += move_and_slide(lin_vel)
	rotation = rotation

func kick(kicking : bool):
	$alive/leg.visible = kicking
	$kick.position.x = 30
	$kick.collision_layer = kicking
	$kick.collision_mask = kicking
#	$alive/leg.visible = !$alive/leg.visible

func set_state(new_state):
	state = new_state

func get_state():
	return state

func set_alive():
	if globals.f_score_count >= 1:
		set_can_kick(1)
	set_state(states['alive'])

	$collision.set_deferred('disabled', 0 )
	$area.set_deferred('monitoring', 1 )
	$alive.show()
	$dead.hide()

func set_dead():
	set_state(states.dead)

	$dead.show()
	$collision.set_deferred('disabled',1)
	$area.set_deferred('monitoring', 0)
	$alive.hide()

	mv = Vector2(0,0)

func set_can_kick(can:bool):
	can_kick = can

func get_can_kick():
	return can_kick

func get_kicked(target):
	if target.get_groups()[0] == 'entity':
		if target.get_groups()[1] != get_groups()[1]:
			target.call_deferred('set_dead')
			target.call_deferred('stop')
			_get_camera_shake().call_deferred('_start',0.12,8,6)
			_get_camera_shake().call_deferred('_vibrate', id, 0.1, 0 , 0.16)

func stop():
	set_physics_process(0)

func hide_elements():
	$alive/leg.hide()
	$alive/gun.hide()
	$dead.hide()
	$kick.collision_layer = 10
	$kick.collision_mask = 10
	$kick.position.y = 0

func _get_camera_shake():
	return get_tree().get_nodes_in_group('camera')[0].get_child(0)

func _ready():
	var chars = ['f','p']
	id = int(get_name().lstrip(chars))
	
	hide_elements()
	add_to_group('entity')
	
# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	
# warning-ignore:return_value_discarded
	$kick.connect('body_entered', self, 'get_kicked')
