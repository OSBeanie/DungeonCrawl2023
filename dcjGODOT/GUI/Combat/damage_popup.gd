extends Node2D

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	$SeraphPanel.hide()
	$SiannPannel.hide()
	
func popup(type : String):
	tween = create_tween()
	tween.tween_property(self, "position", self.position + Vector2(0, 100), 0.6)
	if type == "Seraph":
		$SeraphPanel.show()
	elif type == "Siann":
		$SiannPannel.show()

	


func _on_timer_timeout():
	if tween != null: 
		tween.kill()
	queue_free()
