extends AudioStreamPlayer

func _process(delta):
	if get_parent().moving:
		self.playing = true
