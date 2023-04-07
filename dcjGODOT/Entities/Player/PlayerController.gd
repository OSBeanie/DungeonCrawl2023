extends Camera3D
var direction = 0
var step_distance = 1.0

var moving = false
var in_melee_combat : bool = false
var action_queue : Array = []


signal died
signal finished_level
signal started_moving
signal finished_moving

func _enter_tree():
	Global.player = self
	


func _process(_delta):
	pass # moved to _unhandled_input()


func _unhandled_input(_event):
	if in_melee_combat: # no moving until combat is resolved
		return
		
	var actions_to_queue = ["turn_left", "turn_right", "move_forwards", "move_backwards"]
	for actionName in actions_to_queue:
		if Input.is_action_just_pressed(actionName):
			action_queue.push_back(actionName)
			if $movetimer.is_stopped(): # execute action immediately
				take_action(action_queue.pop_front())


func change_direction(action_name):
	if action_name == "turn_left":
		direction += 1
	elif action_name == "turn_right":
		direction -= 1
	#direction = direction % 4 # wrap to 0 # not needed.. causes rotating artifact when it loops.

	if Global.user_prefs["move_instantly"] == true:
		self.rotation_degrees.y = (direction * 90)
	else:
		var tween = create_tween()
		var duration = 0.3
		tween.tween_property(self, "rotation_degrees", Vector3(0,direction * 90,0), duration)


func take_action(action_name):
	if Global.user_prefs["move_instantly"] == false:
		$movetimer.start()
	
	if action_name in ["turn_left", "turn_right"]:
		change_direction(action_name)
	elif action_name == "move_forwards":
		if !$forwardRayCast3D.is_colliding():
			move(action_name)
		elif "robot" in $forwardRayCast3D.get_collider().name.to_lower():
			#$movetimer.start()
			initiate_melee_combat()
	elif action_name == "move_backwards":
		# don't initiate combat unless you're facing the enemy
		# but you walls and robots still block you
		if !$backwardRayCast3D.is_colliding():
			move(action_name)


func move(action_name):
	var move_dir = 1
	if action_name == "move_backwards":
		move_dir = -1
	
	if Global.user_prefs["move_instantly"] == true:
		$SingleFootstepNoise.start()
	else:
		$FootstepsNoise.start()
	#separate method: get_parent().get_node("movetimer").start()
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("_on_player_finished_moving"):
			enemy._on_player_finished_moving()
	
	if Global.user_prefs["move_instantly"] == true:
		#original movement: 
		self.position += (Vector3.FORWARD * step_distance * 2).rotated(Vector3.UP, self.rotation.y)
	else:
		var tween = self.create_tween()
		var dirVector = -self.get_camera_transform().basis.z * step_distance * move_dir
		
		tween.tween_property(self, "position", position + dirVector, .2)
		tween.tween_interval(.1)
		tween.tween_property(self, "position", position + (2.0*dirVector), .2)


func take_damage(damage): # for Beanie
	# subtract from health, play a noise, camera shake, possibly die
	pass


func initiate_melee_combat():
	in_melee_combat = true
	$HUD.initiate_melee_combat()

func _on_melee_combat_resolved():
	var NPC = $forwardRayCast3D.get_collider()

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



func _on_movetimer_timeout():
	if action_queue.size() > 0:
		take_action(action_queue.pop_front())
