#tool
extends 'res://scripts/entity.gd'

#var react_time = 400
var ball_dist = 16
export var bullet_velocity = 10
var Bullet = preload('res://assets/bullet.tscn')
onready var goal = get_parent().get_node('field/goal')
onready var players = get_tree().get_nodes_in_group('player')
var is_shooting = false
var to_goal = false
#var BulletShoot

func _physics_process(dt):
#	if Input.is_action_pressed('kick%s' % id ):
#		shoot(id)
	if is_physics_processing():
		if !is_shooting:
			move(dt)
		if to_goal:
			go_to_goal(id)
	else:
		pass

func move(dt):
	var pos = position
	if abs(ball.position.x) > abs(pos.x) && abs(ball.position.x - pos.x) > ball_dist:
		pos.x -= ball.position.x + (ball_dist / 2)
	if abs(ball.position.y) > abs(pos.y) && abs(ball.position.y - pos.y) > ball_dist:
		pos.y += -ball.position.y + (ball_dist / 2)

	position += move_and_slide(-pos * dt * 0.5)

func activate(body, id):
	if !is_physics_processing():
		set_physics_process(true)
	
#	print(body.state)
	
	if body.is_in_group('player'):
		if body.state == body.states.ALIVE:
			is_shooting = 1
			shoot(id)
		else:
			is_shooting = 0
	else:
#	if body.state.DEAD:
		set_physics_process(0)
#		is_shooting = 0

func shoot(id):
	look_at(players[id].position)
	
	$gun.visible = true
	
	var bullet = Bullet.instance()
	bullet.position = ($gun/BulletShoot as Position2D).global_position
	bullet.linear_velocity += Vector2(bullet_velocity, bullet_velocity)
	bullet.add_collision_exception_with(self)#, is_in_group('fasc'))
#	bullet.applied_force
#	print(bullet.position)
#	get_parent().get_node('ball').linear_velocity = Vector2(mv_x,mv_y) * BALL_VELOCITY
#	print(get_parent().get_node('ball').applied_focrce)
	
	print('shoot them!')

func go_to_goal(id):
	to_goal = true
	if get_name() != 'f%s' % id:
		pass
	elif get_name() == 'f%s' % id:
		position.x += goal.position.x * get_process_delta_time() * 0.3
		position.y += -goal.position.y * get_process_delta_time() * 0.3
#		print('go to goal')

func _ready():
#	BulletShoot = Position2D
#	add_child(BulletShoot, true)

	add_to_group('fasc')
	set_physics_process(0)
	
#	print('fasc ', get_groups())
	
	if id == 0:
		rotation = 15
		position = ball.position - Vector2(ball_pos_calc, ball_pos_calc)
	if id == 1:
#		rotation = 180
		position = ball.position - Vector2(ball_pos_calc, -ball_pos_calc)
		
	$chest.set_self_modulate(Color.brown)