extends Control

var directions = ["N", "W", "S", "E"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$PopupPanel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.player != null:
		$DirectionLabel.text = directions[Global.player.direction % directions.size()]


func _on_close_button_pressed():
	$PopupPanel.hide()


func _on_direction_label_pressed():
	$PopupPanel.popup_centered_ratio(0.67)
	$PopupPanel/VBoxContainer/CloseButton.grab_focus()
