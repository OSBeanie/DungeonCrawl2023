extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level01/Ceiling.show()
	change_graphics()

func change_graphics():
	if Global.user_prefs["low_spec"] == true:
		$WorldEnvironment.environment = preload("res://Levels/WorldEnvironments/LowSpec.tres")
	else:
		$WorldEnvironment.environment = preload("res://Levels/WorldEnvironments/HighSpec.tres")
