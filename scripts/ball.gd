extends RigidBody2D

signal ball
signal shoot
signal goal
signal reset
signal sfx

var ball_pos
#var fasc

var last_entity = null

func entered(body):
	if body.is_in_group('player'):
		last_entity = 'player'
		emit_signal('shoot', body, body.id)
	if body.is_in_group('fasc'):
		last_entity = 'fasc'
		emit_signal('goal', body.id )
# 		print(body.id)
	if body.is_in_group('entity'):
		emit_signal('sfx', globals.hit01)
	if body.is_in_group('goal'):
		emit_signal('sfx', globals.score)

func exited(body):
	if body.is_in_group('entity'):
		emit_signal('ball', body)

func out_of_bounds(_body):
	if last_entity == 'player':
		globals.center_txt.text = 'out of bounds!'
		globals.center_txt.set_visible(true)
		emit_signal('sfx', globals.score)
		yield(get_tree().create_timer(globals.RESP_TIME),'timeout')
		globals.emit_signal("post_goal")

func fasc_ready(fasc):
	for i in fasc:
		connect('shoot', i , 'activate')
		connect('goal', i , 'go_to_goal')
		connect('reset', i , 'set_positions')
		connect('ball', i , 'go_to_ball')

func set_ball_position():
	ball_pos = get_viewport().get_size() * Vector2(0.52, 0.48) #.479
	position = ball_pos
	set_linear_velocity(Vector2())
	set_angular_velocity(0)
	emit_signal('reset')
	emit_signal('sfx', globals.start_sfx)

func _ready():
	add_to_group('ball')
	set_ball_position()

	$area.connect('body_entered', self, 'entered')
	$area.connect('body_exited', self, 'exited')
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
