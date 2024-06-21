#tool
extends 'res://scripts/entity.gd'

#var react_time = 400
var ball_dist = 16
#export var bullet_velocity = 250
var Bullet = preload('res://assets/bullet.tscn')
onready var goal = get_parent().get_node('field/goal')
onready var players = get_tree().get_nodes_in_group('player')
var is_shooting = false
var to_goal = false
#var BulletShoot

var cooldown = 0
var GUN_COOLDOWN = 0.6

func _physics_process(dt):
#	if is_physics_processing():
	if !is_shooting:
		move(dt)
	elif is_shooting:
		move(0)
		#shoot(dt)
	if to_goal:
		go_to_goal(id)
#	else:
#		pass

func move(dt):
	var pos = position
	if abs(ball.position.x) > abs(pos.x) && abs(ball.position.x - pos.x) > ball_dist:
		pos.x -= ball.position.x + (ball_dist)
	if abs(ball.position.y) > abs(pos.y) && abs(ball.position.y - pos.y) > ball_dist:
		pos.y += -ball.position.y + (ball_dist)

	position += move_and_slide(-pos * dt * 0.5)
	look_at(ball.position)

func activate(body, id):
	if get_state() == states.dead:
		return
	else:
		set_physics_process(true)
	
	match body.state:
		0:
			call_deferred('shoot',id)

func shoot(id):
	is_shooting = 1
	emit_signal('sfx', globals.bang)
	cooldown -= get_physics_process_delta_time()
	look_at(players[id].position)# + Vector2(90,90))
	
	$alive/gun.visible = 1
	
	if cooldown < 1:
		is_shooting = 0
		var bullet = Bullet.instance()
		bullet.position = $alive/gun/BulletShoot.global_position
		bullet.rotation = rotation
		get_parent().add_child(bullet)
#		globals.center_txt.text = 'shoot them!'
		cooldown = GUN_COOLDOWN

func go_to_ball(_id):
	is_shooting = false
	to_goal = false

func go_to_goal(id):
	to_goal = true
	if get_name() == 'f%s' % id:
		position.x += goal.position.x * get_process_delta_time() * 0.3
		position.y += -goal.position.y * get_process_delta_time() * 0.3
		look_at(goal.position)
#		print('go to goal')

func set_positions():
	match id:
		0:
			position = ball.position - Vector2(ball_pos_calc, ball_pos_calc)
		1:
			position = ball.position - Vector2(ball_pos_calc, -ball_pos_calc)

	look_at(ball.position)
	set_physics_process(0)
	hide_elements()
	set_alive()

func _ready():
	set_positions()
	add_to_group('fasc')
	for c in states.keys():
		get_node(c).get_node('chest').set_self_modulate(Color.lightblue)
