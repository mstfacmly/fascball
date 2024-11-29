extends 'res://scripts/entity.gd'

onready var fasc = get_tree().get_nodes_in_group('fasc')

func _init():
	add_to_group('player')

func _ready():
	for c in states.keys():
		get_node(c).get_node('chest').set_self_modulate(Color.green)
	set_positions()

func _physics_process(_dt):
	if globals.game_on != false:
		if state != states.dead:
			get_input()
		else:
			set_dead()

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if get_can_kick():
		kick(Input.is_action_pressed('kick%s' % id))

func set_positions():
	match id:
		0:
			position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
		1:
			position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
	look_at(ball.position)

	set_alive()
