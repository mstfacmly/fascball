extends Node

export(int,20) var field_size = 20
var goal
var green
var pos_array = []

"""func _input(event):
	if Input.is_key_pressed(79):
		generate_field()
	if Input.is_key_pressed(80):
		clear_goal()"""

func generate_field():
	for i in rand_range(0,field_size):
		green = preload('res://assets/fasc/green.tscn').instance()
		green.set_z_index(-1)
		add_child_below_node($field,green)
		green.name = 'green'+str(i)
		green.position.x = 320 - (64*3) * i
		pos_array.append(i)
	generate_goal(get_node('green%s' % pos_array.back()).position)
	$ui/margin/ui/center/txt.get('custom_fonts/font').set_size(42)

func generate_goal(pos):
	goal = preload('res://assets/fasc/goal.tscn').instance()
	add_child_below_node($field, goal)
	goal.position.x = pos.x - 190

func clear_goal():
	green.queue_free()
	goal.queue_free()
	pos_array.clear()
	generate_field()

func _ready():
	$field/grid.set_z_index(-1)
	generate_field()
