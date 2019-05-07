extends AudioStreamPlayer

func _ready():
#warning-ignore:return_value_discarded
	connect('finished', self, 'end')
	stop()

func play_sfx(sfx):
	stream = sfx
	play()
	
func end():
	stop()
#	queue_free()