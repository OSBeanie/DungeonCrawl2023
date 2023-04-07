"""
some audio needs to persist past the life of the originating object.
This will add a self-terminating copy of itself to the root, so it can finish playing audio with long reverb, even after the parent object has queued_free()
"""

extends AudioStreamPlayer
@export var jitter : float = 0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	



func start():
	var newAudioFX = self.duplicate()
	StageManager.add_child(newAudioFX)
	

	newAudioFX.finished.connect(newAudioFX.queue_free)
	
	newAudioFX.set_pitch_scale(randf_range(1.0 - jitter, 1.0 + jitter))
	newAudioFX.play()

