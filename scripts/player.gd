extends 'res://scripts/entity.gd'

enum states {ALIVE,DEAD}
var state = states.ALIVE

func get_input():
	mv.x = Input.get_action_strength('right%s' % id) - Input.get_action_strength('left%s' % id)
	mv.y = Input.get_action_strength('down%s' % id) - Input.get_action_strength('up%s' % id)
	
	if Input.is_action_pressed('kick%s' % id):
		kick()
	elif Input.is_action_just_released('kick%s' % id):
		$leg.hide()

#warning-ignore:unused_argument
func _physics_process(dt):
	if state != states.DEAD: # == states.ALIVE:
#		set_physics_process(1)
		get_input()
	else:
		$collision.set_disabled(true)
		$area.set_monitoring(false)
		set_physics_process(0)

#func _process(dt):
#	if reload_time >= 0.0:
#		print(reload_time)
#		reload_time -= dt
#		if reload_time <= 0.0 :
#			get_tree().reload_current_scene()

func entered(body):
	if body.is_in_group('player') && body.state != states.DEAD:
		if id == body.id:
			state = states.DEAD
			globals.dead_count += 1
	if globals.dead_count >= 2:
		globals.center_txt.text = fasclines[randi() % fasclines.size()]
		globals.center_txt.show()
		globals.f_score.text = str(+1)
		reload_time = globals.RESP_TIME

func _ready():
#	set_process(0)
	add_to_group('player')
	
	if id == 0:
		position = ball.position + Vector2(ball_pos_calc, ball_pos_calc)
	if id == 1:
		position = ball.position + Vector2(ball_pos_calc, -ball_pos_calc)
	look_at(ball.position)
	
	$chest.set_self_modulate(Color.green)