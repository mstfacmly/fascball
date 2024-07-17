extends Node2D
#extends 'res://scripts/cam.gd'

# https://youtu.be/_DAvzzJMko8
# https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html
# https://shaggydev.com/2022/02/23/screen-shake-godot/

onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var impact = 0.0
var max_offset = Vector2(100,75)
var is_hit = false
export(float,0.0,1.0) var hit_amount = 0.5

export var amplitude = 0

func _hit(amount):
	return min(impact + amount, 1.0)

func _shake(amount):
	amount = pow(_hit(amount),2)
	noise_y += 1
	get_parent().offset = Vector2(max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y),
		max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y))

func _noise_gen():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _ready():
	_noise_gen()

#func _input(event):
#	if event is InputEventKey:
#		if event.pressed && event.scancode == KEY_F3:
#			_start()
#			is_hit = true
#		else: is_hit = false

func _new_shake():
	var rand = Vector2(rand_range(-amplitude,amplitude),
						rand_range(-amplitude,amplitude))
	$shake_tween.interpolate_property( get_parent() , 'offset', get_parent().offset , rand, $freq.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$shake_tween.start()

func _start(duration = 0.2, freq = 32 , ampli = 16):
	self.amplitude = ampli
	
	$duration.wait_time = duration
	$freq.wait_time = 1 / float(freq)
	$duration.start()
	$freq.start()
	
	_new_shake()

func _reset():
	$shake_tween.interpolate_property( get_parent() , 'offset', get_parent().offset , Vector2() , $freq.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$shake_tween.start()

func _on_freq_timeout():
	_new_shake()

func _on_duration_timeout():
	_reset()
	$freq.stop()

func _on_anims_animation_finished(anim_name):
	match anim_name:
		'slam':
			_start(0.48,32,16)
			for i in Input.get_connected_joypads():
				_vibrate(i,0,1,0.76)
		'_':
			return

func _vibrate(id, weak, strong , duration):
	Input.start_joy_vibration(id, weak, strong, duration)
