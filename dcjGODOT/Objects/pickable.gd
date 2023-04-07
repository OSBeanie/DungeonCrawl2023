extends Area3D

@export var stat = "Health"

var picked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_area_entered(area):
	if !picked and area.is_in_group("player"):
		print("Pickup detected by : ", area.name)
		pickup(area)

func pickup(pickerUpper):
	picked = true
	# play a noise, wiggle, disappear
	# maybe add to player health

	var vector_to_player = pickerUpper.global_position - self.global_position
	var distance = 0.2
	var tween = create_tween()
	tween.tween_property(self, "position", position - vector_to_player * distance, 0.2)
	tween.tween_interval(0.2)
	tween.tween_property(self, "position", position + vector_to_player, 0.3)
	
	if stat == "Health":
		Global.player_stats["Health"] += 5
		Global.player.hud.update()
		
	$AnimationPlayer.play("pickup")
	$PickupNoise.start()
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pickup":
		queue_free()
