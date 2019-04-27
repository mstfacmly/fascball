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

func _ready():
	add_to_group('player')
	
	if id == 0:
		rotation = -120
		position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
	if id == 1:
		rotation = 180
		position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
		
	$chest.set_self_modulate(Color.green)