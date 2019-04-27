extends 'res://scripts/entity.gd'

enum states {ALIVE,DEAD}
var state = states.ALIVE

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if Input.is_action_pressed('kick%s' % id):
		kick()

#warning-ignore:unused_argument
func _physics_process(dt):
	get_input()
	
	if state != states.DEAD: # == states.ALIVE:
		set_physics_process(1)
	else:
		set_physics_process(0)

func entered(body):
	print(body.get_groups())
	if body.is_in_group('bullet'):
		#get_parent().get_node('p%s'%id).state = states.DEAD
		state = states.DEAD
		globals.f_score.text = str(+1)

func _ready():
	add_to_group('player')
	
	if id == 0:
#	rotation_degrees = -45
		position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
	if id == 1:
#	rotation_degrees = -135
		position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
	look_at(ball.position)
	
	$chest.set_self_modulate(Color.green)
#	pos_calc = position.x - ball.position.x
#	rot_mod = pos_calc / abs(pos_calc)
#	rotation = -90 * rot_mod