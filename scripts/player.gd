extends 'res://scripts/entity.gd'

onready var fasc = get_tree().get_nodes_in_group('fasc')

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if get_can_kick():
		kick(Input.is_action_pressed('kick%s' % id))

func _physics_process(_dt):
	if globals.game_on != false:
		if state != states.dead:
			get_input()
		else:
			set_dead()

func shot(body):
	if body.is_in_group('player'):
		match id:
			body.id:
				emit_signal('sfx', globals.hit_sounds[randi() % globals.hit_sounds.size()])#%rand_range(0,2))
				_get_camera_shake().call_deferred('_start',0.24,32,8)
				_get_camera_shake().call_deferred('_vibrate', id, 0.2, 0 , 0.48)
				set_dead()
				globals.death_count(1)

func set_positions():
	match id:
		0:
			position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
		1:
			position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
	look_at(ball.position)

	set_alive()

func _ready():
	add_to_group('player')
	for c in states.keys():
		get_node(c).get_node('chest').set_self_modulate(Color.green)
	set_positions()
