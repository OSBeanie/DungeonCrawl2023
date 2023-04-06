extends Control


var robot_textures = {
	"normal":"res://GUI/HUD/RobotHappyR1.png",
	"hover":"res://GUI/HUD/RobotHappyR2.png",
}

func _ready():
	$VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/StartCampaignButton.grab_focus()


func _on_button_mouse_entered():
	#hover
	%RobotTexture.texture = load(robot_textures["hover"])
	$HoverNoise.start()

func _on_button_mouse_exited():
	%RobotTexture.texture = load(robot_textures["normal"])

