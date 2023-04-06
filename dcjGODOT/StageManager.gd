extends Node

var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_scene_to_packed(newScene:PackedScene):
	# play a transition animation and audio event
	# notify track current scene
	get_tree().change_scene_to_packed(newScene)


func change_scene_to_file(newScenePath : String):
	if ResourceLoader.exists(newScenePath):
		var next_scene = ResourceLoader.load(newScenePath)
		change_scene_to_packed(next_scene)

