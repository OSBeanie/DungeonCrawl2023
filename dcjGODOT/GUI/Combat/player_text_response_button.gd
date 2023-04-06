extends Button

signal response_chosen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_pressed():
	response_chosen.emit(text)
