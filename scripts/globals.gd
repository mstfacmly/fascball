extends Node

signal sfx
signal post_goal

var version = '0.7.2'
var zio_ed_ver = '0.1948'

onready var title = $'/root/field/ui/margin/title'
onready var start = $'/root/field/ui/margin/title/start'
onready var ui = $'/root/field/ui/margin/ui'
onready var f_score = $'/root/field/ui/margin/ui/score/score_f'
onready var p_score = $'/root/field/ui/margin/ui/score/score_p'
onready var center_txt = $'/root/field/ui/margin/ui/center/txt'

var start_sfx = preload('res://assets/sfx/Collect_Point_00.wav')
var score = preload('res://assets/sfx/Climb_Rope_Loop_00.wav')
var bang = preload('res://assets/sfx/Explosion_02.wav')
var expl = preload('res://assets/sfx/Explosion_04.wav')
var hit00 = preload("res://assets/sfx/Hit_01.wav")
var hit01 = preload("res://assets/sfx/Hit_02.wav")
var hit02 = preload("res://assets/sfx/Hit_03.wav")

var hit_sounds = [hit00,hit01,hit02]

var theme = preload('res://assets/music/wyver9_Fast Level.ogg')
var theme_zioed = preload('res://assets/music/settler-colony.ogg')

var game_on = false
var f_score_count = 0
var p_score_count = 0
var dead_count = 0
var reload_time = 0
export var RESP_TIME = 3

var fasclines : Array
var accuse : Array
var accuse_lines : Array

func _ready():
	connect('sfx', $'/root/field/ui/sfx', 'play_sfx')
	connect('post_goal', $'/root/field/field/goal','_post_goal')

func _score_counter():
	f_score.text = str(f_score_count)
	p_score.text = str(p_score_count)
	emit_signal('sfx', score)
	yield(get_tree().create_timer(RESP_TIME),'timeout')
	emit_signal("post_goal")

func death_count(death_count):
	dead_count += death_count
#	print(dead_count)
	if dead_count >= 2:
#		reload_time = RESP_TIME
		dead_count = 0
		if !fasclines.empty():
			show_text(fasclines[randi() % fasclines.size()],true)
		f_score_count += 1
		_score_counter()

func read_fasclines(lines):
	var file = File.new()
	file.open(lines, File.READ)
	while !file.eof_reached():
		var content = file.get_line()
		if !content.length() <= 0:
			if '<accuse>' in content:
				append_accusation(content)
			else:
				fasclines.append(content)
	file.close()
#	print(fasclines)

func append_accusation(line):
	var file = File.new()
	file.open("res://assets/accuse.txt", File.READ)
	while !file.eof_reached():
		var content = file.get_line()
		if !content.length() <= 0:
			accuse.append(content)
	file.close()
	for i in accuse:
		fasclines.append(line.replace('<accuse>',i))
		accuse_lines.append(line.replace('<accuse>',i))

func clear_fasclines(lines):
	var file = File.new()
	file.open(lines, File.READ)
	while !file.eof_reached():
		var content = file.get_line()
		fasclines.erase(content)
	
	if !accuse_lines.empty():
		for i in accuse_lines:
			fasclines.erase(i)
		accuse_lines.clear()

	file.close()
#	print(fasclines)

func show_text( text, show:bool ):
		center_txt.text = text
		center_txt.get('custom_fonts/font').set_size(48 / (center_txt.get_total_character_count() * 0.1))
		center_txt.set_visible(show)
