extends Area3D

@export var next_scene : String
var next_scene_packed : PackedScene

@export var final_exit : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	next_scene_packed = load(next_scene)





func _on_area_entered(area):
	if area.get_parent() == Global.player:
		print("You Win! Congratulations")
		if next_scene != null and next_scene != "":
			if final_exit == true:
				Global.exit_found = true
			StageManager.change_scene_to_packed(next_scene_packed)
