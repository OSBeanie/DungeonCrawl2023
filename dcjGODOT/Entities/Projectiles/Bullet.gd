extends Node3D

@export var tween_duration : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_started_moving():
	pass


func _on_player_finished_moving():
	# move forward 1 step
	var tween = create_tween()
	var dirVector = basis.x.normalized()
	var distance = 1.0
	tween.tween_property(self, "position", position + dirVector * distance, tween_duration)
	

	
func die():
	queue_free()
