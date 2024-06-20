extends 'res://scripts/entity.gd'

#signal reset_fasc

onready var fasc = get_tree().get_nodes_in_group('fasc')

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if get_can_kick():
		kick(Input.is_action_pressed('kick%s' % id))

func _physics_process(_dt):
	if globals.game_on != false:
		if state != states.dead: # == states.ALIVE:
			get_input()
		else:
			set_dead()

func shot(body):
	if body.is_in_group('player'):# && body.state != states.DEAD:
		get_tree().get_nodes_in_group('camera')[0].get_child(0).call_deferred('_start',0.2,32,8)
		match id:
			body.id:
#		if id == body.id:
				emit_signal('sfx', globals.hit_sounds[randi() % globals.hit_sounds.size()])#%rand_range(0,2))
				set_dead()
				globals.death_count(1)

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
