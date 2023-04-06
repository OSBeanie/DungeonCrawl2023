extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move():
	# face the player for now.
	if Global.player != null:
		var desiredRot = global_position.angle_to(Global.player.global_position)
		
		rotation.y = snapped(desiredRot.y, PI/2.0)

func shoot():
	if Global.player != null:
		print(self.name + " is shooting.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_started_moving():
	move()

func _on_player_finished_moving():
	shoot()
