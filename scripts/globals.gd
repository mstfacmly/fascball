extends Node

#warning-ignore:unused_class_variable
onready var title = $'/root/field/ui/margin/title'
#warning-ignore:unused_class_variable
onready var start = $'/root/field/ui/margin/title/start'
#warning-ignore:unused_class_variable
onready var ui = $'/root/field/ui/margin/ui'
onready var f_score = $'/root/field/ui/margin/ui/score/score_f'
onready var p_score = $'/root/field/ui/margin/ui/score/score_p'
onready var center_txt = $'/root/field/ui/margin/ui/center/txt'

#warning-ignore:unused_class_variable
var start_sfx = preload('res://assets/sfx/Collect_Point_00.wav')
#warning-ignore:unused_class_variable
var score = preload('res://assets/sfx/Climb_Rope_Loop_00.wav')
#warning-ignore:unused_class_variable
var bang = preload('res://assets/sfx/Explosion_02.wav')
#warning-ignore:unused_class_variable
var hit00 = preload("res://assets/sfx/Hit_01.wav")
#warning-ignore:unused_class_variable
var hit01 = preload("res://assets/sfx/Hit_02.wav")
#warning-ignore:unused_class_variable
var hit02 = preload("res://assets/sfx/Hit_03.wav")

#warning-ignore:unused_class_variable
var hit_sounds = [hit00,hit01,hit02]

#warning-ignore:unused_class_variable
var game_on = false
var f_score_count = 0
var p_score_count = 0
var dead_count = 0
#warning-ignore:unused_class_variable
var reload_time = 0
#warning-ignore:unused_class_variable
export var RESP_TIME = 5

var fasclines = [] #[

#'get\nalong!',
#'fair\nand\nbalanced\nnews!',
#'so much\nfor the\ntolerant\nleft!',
#'peace\nenforced!',
#'freedom\nof\nspeech!',
#'the\ngay\nagenda!',
#'the\nsjw\nagenda!',
#'the\ntrans\nagenda!',
#'the\njewish\nagenda!',
#'the\nmuslim\nagenda!',
#'subscribe\nto\npewdiepie!',
#'all hail\nthe\nlobster king!',
#'where\nwere they\nradicalized?',
#'islam\nis not\na race!',
#'judaism\nis not\na race!',
#'the real racists\nare those who\ncall others\nracist!',
#'people don\'t\ntalk to\neach other\nnowadays!',
#'you\'re the\nreal fascists!',
#'antifa are\nthe\nreal fascists!',
#'why won\'t you\ndebate us?',
#'why can\'t\nwe have\na civil debate?',
#'what about\nour poor first?',
#'what about\nthe men?',
#'what about\nour women?',
#'illegal aliens!',
#'the mexicans!',
#'the arabs!',
#'cultural marxism!',
#'we identify as\nan attack\nchopper',
#'they\'re breaking\n windows!'
#]

#warning-ignore:unused_argument
func _physics_process(delta):
	f_score.text = str(f_score_count)
	p_score.text = str(p_score_count)
	
	if dead_count >= 2:
		reload_time = RESP_TIME
		dead_count = 0
		center_txt.text = fasclines[randi() % fasclines.size()]
		center_txt.show()
		f_score_count = f_score_count + 1
		
func read_fasclines():
	var file = File.new()
	file.open('res://assets/fasclines', File.READ)
	while !file.eof_reached():
		var content = file.get_line()
		fasclines.append(content)
	file.close()
#		fasclines.close()
#		return content

func _ready():
	read_fasclines()