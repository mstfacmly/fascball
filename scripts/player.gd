extends 'res://scripts/entity.gd'

func _input(ev):
	mv.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	mv.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	
	if ev.is_action_pressed('ui_accept'):
		kick()
		
func _ready():
	add_to_group('player')

	position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)