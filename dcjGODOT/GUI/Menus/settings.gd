extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	%MoveInstantlyButton.button_pressed = Global.user_prefs["move_instantly"]
	%LowSpecButton.button_pressed = Global.user_prefs["low_spec"]

func _on_move_instantly_button_toggled(button_pressed):
	Global.user_prefs["move_instantly"] = button_pressed
	




func _on_low_spec_button_toggled(button_pressed):
	Global.user_prefs["low_spec"] = button_pressed
	if StageManager.current_scene.has_method("change_graphics"):
		StageManager.current_scene.change_graphics()



