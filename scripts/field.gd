extends Node

func generate_field():
	var pos_array = []
	for i in rand_range(0,20):
		var green = preload('res://assets/fasc/green.tscn').instance()
		add_child_below_node($field ,green)
		green.name = 'green'+str(i)
		green.position.x = 320 - (64*3) * i
		pos_array.append(i)
	print(pos_array.back())
	generate_goal(get_node('green%s' % pos_array.back()).position)
	$ui/margin/ui/center/txt.get('custom_fonts/font').set_size(42)


func generate_goal(pos):
	var goal = preload('res://assets/fasc/goal.tscn').instance()
	add_child_below_node($field, goal)
	goal.position.x = pos.x - 190

func _ready():
	generate_field()
