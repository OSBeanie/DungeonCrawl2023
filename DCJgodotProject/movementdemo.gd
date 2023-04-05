extends Camera3D
var direction = 0

func _process(delta):
	if Input.is_action_just_pressed("a"):
		if direction <= 2:
			direction = direction + 1
		else:
			direction = 0
	self.rotation_degrees.y = (direction * 90)
	if Input.is_action_just_pressed("d"):
		if direction >= 1:
			direction = direction - 1
		else:
			direction = 3
	self.rotation_degrees.y = (direction * 90)
	if Input.is_action_just_pressed("w"):
		self.position += (Vector3.FORWARD * 1).rotated(Vector3.UP, self.rotation.y)
