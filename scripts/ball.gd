extends RigidBody2D

func _ready():
	var pos = Vector2()
	pos.y = get_viewport().size.y * .5
	pos.x = get_viewport().size.x * .5
		
	position = pos