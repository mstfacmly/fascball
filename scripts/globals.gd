extends Node

onready var f_score = $'/root/field/ui/margin/align/score/score_f'
onready var p_score = $'/root/field/ui/margin/align/score/score_p'
onready var center_txt = $'/root/field/ui/margin/align/center/txt'

var f_score_count = 0
var p_score_count = 0
var dead_count = 0
#warning-ignore:unused_class_variable
var reload_time = 0
#warning-ignore:unused_class_variable
export var RESP_TIME = 5

var fasclines = [
'get\nalong!',
'fair\nand\nbalanced\nnews!',
'so much\nfor the\ntolerant\nleft!',
'peace\nenforced!',
'freedom\nof\nspeech\nsaved!',
'the\ngay\nagenda',
'the\nsjw\nagenda!',
'the\ntrans\nagenda!',
'the\njewish\nagenda!',
'the\nmuslim\nagenda!',
'subscribe\nto\npewdiepie!',
'all hail\nthe\nlobster king!',
'where\nwere they\nradicalized?',
'islam\nis not\na race',
'the real racists\nare those who\ncall others\nracist!',
'people don\'t\ntalk to\neach other\nnowadays!',
'you\'re the\nreal fascists!',
'why won\'t you\ndebate me?',
'why can\'t\nwe have\na civil debate?',
'what about\nour poor first?',
'what about\nthe men?',
'we identify as\nan attack\nchopper',
'they\'re breaking\n windows!'
]

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