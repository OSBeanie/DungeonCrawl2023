extends PopupPanel

@export_multiline var default_text = "You make a good point. I think you're right.
Thanks."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_close_popup_button_pressed():
	hide()


func set_dialog_text(robot):
	$CenterContainer/VBox/EnemyName.text = robot.robot_name
	$CenterContainer/VBox/EnemyConcessionSpeech.text = robot.dialog_text
	

func reset_dialog_text():
	$CenterContainer/VBox/EnemyName.text = "SIANN"
	
	$CenterContainer/VBox/EnemyConcessionSpeech.text = default_text

		
func _on_about_to_popup():
	
	$CenterContainer/VBox/ClosePopupButton.grab_focus()
