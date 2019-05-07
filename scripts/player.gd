extends 'res://scripts/entity.gd'

#signal reset_fasc

enum states {ALIVE,DEAD}
var state = states.ALIVE
#warning-ignore:unused_class_variable
onready var fasc = get_tree().get_nodes_in_group('fasc')

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if Input.is_action_just_pressed('kick%s' % id):
		kick()
	elif Input.is_action_just_released('kick%s' % id):
		kick()

#warning-ignore:unused_argument
func _physics_process(dt):
	if globals.game_on != false:
		if state != states.DEAD: # == states.ALIVE:
			get_input()
		else:
			$collision.set_disabled(true)
			$area.set_monitoring(false)
			mv = Vector2(0,0)
			$leg.hide()

func shot(body):
	if body.is_in_group('player') && body.state != states.DEAD:
		if id == body.id:
			emit_signal('sfx', globals.hit_sounds[randi() % globals.hit_sounds.size()])#%rand_range(0,2))
			state = states.DEAD
			globals.dead_count += 1
	
func set_positions():
	if id == 0:
		position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
	if id == 1:
		position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
	look_at(ball.position)

	state = states.ALIVE
	$collision.set_disabled(false)
	$area.set_monitoring(true)

func _ready():
#	set_process(0)
	add_to_group('player')
	$chest.set_self_modulate(Color.green)
	set_positions()