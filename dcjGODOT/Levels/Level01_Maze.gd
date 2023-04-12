extends Node3D

func _enter_tree():
	StageManager.current_scene = self

# Called when the node enters the scene tree for the first time.
func _ready():
	$Level01/Ceiling.show()
	change_graphics()

func change_graphics():
	if Global.user_prefs["low_spec"] == true:
		$WorldEnvironment.environment = load("res://Levels/WorldEnvironments/LowSpec.tres")
	else:
		$WorldEnvironment.environment = load("res://Levels/WorldEnvironments/HighSpec.tres")
