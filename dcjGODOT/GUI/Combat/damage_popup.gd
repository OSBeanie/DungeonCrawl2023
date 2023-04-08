extends Node2D

var tween
var tween_vector : Vector2 = Vector2(0, -100)
# Called when the node enters the scene tree for the first time.
func _ready():
	$SeraphPanel.hide()
	$SiannPanel.hide()
	$HealthPanel.hide()
	
func popup(type : String):
	if type == "Seraph":
		$SeraphPanel.show()
		tween_vector = Vector2(-100, -100)
	elif type == "Siann":
		$SiannPanel.show()
		tween_vector = Vector2(100, -100)
	elif type == "Health":
		tween_vector = Vector2(0, -100)
		$HealthPanel.show()

	tween = create_tween()
	tween.tween_property(self, "position", self.position + tween_vector, 0.6)
	


func _on_timer_timeout():
	if tween != null: 
		tween.kill()
	queue_free()
