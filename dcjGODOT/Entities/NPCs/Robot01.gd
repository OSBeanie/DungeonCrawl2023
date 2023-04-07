extends CharacterBody3D

@export var track_player :bool = true

@export var requires_persuasion : bool = true

@export_multiline var dialog_text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move():
	# face the player for now.
	if Global.player != null:
		var desiredRot = global_position.angle_to(Global.player.global_position)
		
		rotation.y = snapped(desiredRot.y, PI/2.0)

func face_player():
	if track_player:
		look_at(Global.player.global_position)


func shoot():
	if Global.player != null:
		#print(self.name + " is shooting.")
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_started_moving():
	move()


func _on_player_finished_moving():
	face_player()
	shoot()

func die():
	# play some animation or whatever.
	queue_free()
