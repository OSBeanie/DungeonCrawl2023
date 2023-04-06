extends Camera3D
var direction = 0
var step_distance = 1.0

var moving = false
var in_melee_combat : bool = false

signal died
signal finished_level
signal started_moving
signal finished_moving

func _enter_tree():
	Global.player = self
	


func _process(delta):
	if in_melee_combat: # no moving until combat is resolved
		return
		
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
	if Input.is_action_just_pressed("move_forwards") and $movetimer.is_stopped() and !$RayCast3D.is_colliding():
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
	elif Input.is_action_just_pressed("move_forwards") and $movetimer.is_stopped and $RayCast3D.is_colliding():
		# hit a wall or NPC
		if "robot" in $RayCast3D.get_collider().name.to_lower():
			$movetimer.start()
			initiate_melee_combat()
	else:
		!moving


func take_damage(damage): # for Beanie
	# subtract from health, play a noise, camera shake, possibly die
	pass


func initiate_melee_combat():
	in_melee_combat = true
	$HUD.initiate_melee_combat()

func _on_melee_combat_resolved():
	var NPC = $RayCast3D.get_collider()

	if "robot" in NPC.name.to_lower() and NPC.has_method("die"):
		NPC.die()
	in_melee_combat = false


func _on_hit_box_area_entered(area):
	if area.is_in_group("enemy_projectiles"):
		if area.get("damage") != null:
			take_damage(area.damage)
	elif "exit" in area.name.to_lower():
		if Global.StageManager != null:
			finished_level.connect(Global.StageManager._on_player_finished_level)
			finished_level.emit()
			$HitBox.monitoring = false # don't send repeat signals, don't take anymore damage

