extends AudioStreamPlayer

func _ready():
	connect('finished', self, 'end')
	stop()

func play_sfx(sfx):
	set_stream(sfx)
	play()
	
func end():
	stop()
#	queue_free()
