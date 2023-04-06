extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/MoveInstantlyButton.button_pressed = Global.user_prefs["move_instantly"]





func _on_move_instantly_button_toggled(button_pressed):
	Global.user_prefs["move_instantly"] = button_pressed
