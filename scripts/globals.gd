extends Node

signal sfx
signal post_goal

var version = 0.6

onready var title = $'/root/field/ui/margin/title'
onready var start = $'/root/field/ui/margin/title/start'
onready var ui = $'/root/field/ui/margin/ui'
onready var f_score = $'/root/field/ui/margin/ui/score/score_f'
onready var p_score = $'/root/field/ui/margin/ui/score/score_p'
onready var center_txt = $'/root/field/ui/margin/ui/center/txt'

var start_sfx = preload('res://assets/sfx/Collect_Point_00.wav')
var score = preload('res://assets/sfx/Climb_Rope_Loop_00.wav')
var bang = preload('res://assets/sfx/Explosion_02.wav')
var hit00 = preload("res://assets/sfx/Hit_01.wav")
var hit01 = preload("res://assets/sfx/Hit_02.wav")
var hit02 = preload("res://assets/sfx/Hit_03.wav")

var hit_sounds = [hit00,hit01,hit02]

var fascpeech_toggle = true

var game_on = false
var f_score_count = 0
var p_score_count = 0
var dead_count = 0
var reload_time = 0
export var RESP_TIME = 3

var fasclines = []

func _physics_process(_delta):
	f_score.text = str(f_score_count)
	p_score.text = str(p_score_count)
	
func death_count(death_count):
	dead_count += death_count
	print(dead_count)
	if dead_count >= 2:
#		reload_time = RESP_TIME
		dead_count = 0
		if fascpeech_toggle:
			center_txt.text = fasclines[randi() % fasclines.size()]
			center_txt.get('custom_fonts/font').set_size(48 / (center_txt.get_total_character_count() * 0.1))
			center_txt.show()
		f_score_count += 1
		emit_signal('sfx', globals.score)
		yield(get_tree().create_timer(RESP_TIME),"timeout")
		emit_signal("post_goal")

func read_fasclines():
	var file = File.new()
	file.open('res://assets/fasclines.txt', File.READ)
	while !file.eof_reached():
		var content = file.get_line()
#		for i in content:
#			print(i*2)
		fasclines.append(content)
		fasclines.shuffle()
	file.close()

func _ready():
# warning-ignore:return_value_discarded
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	read_fasclines()
# warning-ignore:return_value_discarded
	connect('post_goal', $'/root/field/field/goal','post_goal')
