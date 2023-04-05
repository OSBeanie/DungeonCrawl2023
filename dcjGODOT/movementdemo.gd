extends Camera3D
var direction = 0
var step_distance = 1.0

var moving = false
func _process(delta):
	if Input.is_action_just_pressed("turn_left"):
		if direction <= 2:
			direction = direction + 1
		else:
			direction = 0
	self.rotation_degrees.y = (direction * 90)
	if Input.is_action_just_pressed("turn_right"):
		if direction >= 1:
			direction = direction - 1
		else:
			direction = 3
	self.rotation_degrees.y = (direction * 90)
	if Input.is_action_just_pressed("move_forwards") and $movetimer.is_stopped():
		moving
		$movetimer.start()
		$AudioStreamPlayer.play()
		#separate method: get_parent().get_node("movetimer").start()
		#original movement: 
		#self.position += (Vector3.FORWARD * 1).rotated(Vector3.UP, self.rotation.y)
		var tween = self.create_tween()
		var dirVector = -self.get_camera_transform().basis.z * step_distance
		
		tween.tween_property(self, "position", position + dirVector, .2)
		tween.tween_interval(.1)
		tween.tween_property(self, "position", position + (2.0*dirVector), .2)
	else:
		!moving
