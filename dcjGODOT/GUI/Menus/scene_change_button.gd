extends Button
@export var next_scene_packed : PackedScene
@export var next_scene_path : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# load the next scene when text starts, so it's ready when users press the button
	if next_scene_packed == null:
		next_scene_packed = load(next_scene_path)


func _on_pressed():
	$AudioStreamPlayer.start()
	
	StageManager.change_scene_to_packed(next_scene_packed)
	
