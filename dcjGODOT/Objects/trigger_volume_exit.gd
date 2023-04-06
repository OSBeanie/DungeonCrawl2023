extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_area_entered(area):
	if area.get_parent() == Global.player:
		print("You Win! Congratulations")
		StageManager.change_scene_to_file("res://GUI/Menus/exit_scene.tscn")
