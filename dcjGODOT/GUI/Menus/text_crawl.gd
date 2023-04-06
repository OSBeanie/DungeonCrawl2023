extends RichTextLabel

@export var msec_between_characters : float = 20.0

var last_reveal_time : float = 0
var full_reveal : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible_characters = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not full_reveal:
		if Time.get_ticks_msec() > last_reveal_time + msec_between_characters:
			last_reveal_time = Time.get_ticks_msec()
			visible_characters += 1
			if visible_ratio == 1.0:
				full_reveal = true

func reveal_all_text():
	full_reveal = true
	visible_ratio = 1.0

