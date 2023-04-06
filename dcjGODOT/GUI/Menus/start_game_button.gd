extends Button
@export var next_scene_packed : PackedScene
@export var next_scene_path : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$AudioStreamPlayer.start()
	
	if next_scene_packed != null:
		StageManager.change_scene_to_packed(next_scene_packed)
	elif next_scene_path != "":
		StageManager.change_scene_to_file(next_scene_path)
