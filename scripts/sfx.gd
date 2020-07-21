extends AudioStreamPlayer

func _ready():
	connect('finished', self, 'end')
	stop()

func play_sfx(sfx):
	stream = sfx
	play()
	
func end():
	stop()
#	queue_free()
