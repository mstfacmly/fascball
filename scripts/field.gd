extends Node

export(int,20) var field_size = 20
var goal
var green
var pos_array = []

func _ready():
	$field/grid.set_z_index(-2)
	generate_field()

func _unhandled_key_input(event):
	if event.scancode == KEY_C && OS.is_debug_build():
		clear_goal()

func generate_field():
	for i in rand_range(0,field_size):
		green = preload('res://assets/fasc/green.tscn').instance()
		$fasc_green.add_child(green)
		green.get_node('grid').set_z_index(-2)
		green.name = 'green'+str(i)
		green.position.x = 320 - (64*3) * i
		pos_array.append(i)
	generate_goal($fasc_green.get_node('green%s' % pos_array.back()).position)

func generate_goal(pos):
	goal = preload('res://assets/fasc/goal.tscn').instance()
	add_child_below_node($fasc_green, goal)
	goal.get_node('grid').set_z_index(-1)
	goal.position.x = pos.x - 190

func clear_goal():
	for i in $fasc_green.get_children():
		i.queue_free()
	goal.queue_free()
	pos_array.clear()
	yield(get_tree().create_timer(0.001),'timeout')
	generate_field()
