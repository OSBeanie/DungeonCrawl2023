@tool
extends MeshInstance3D

@export_color_no_alpha var light_color = Color.WEB_MAROON : set = set_color, get = get_color



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func set_color(newColor):
	
	light_color = newColor
	#self.mesh.material.emission = newColor
	$OmniLight3D.light_color = newColor

func get_color():
	return light_color
