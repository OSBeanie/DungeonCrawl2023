extends Node3D
var direction = 0
var prev_direction = 0
var directions = ["N", "W", "S", "E"]
var actions_to_queue = ["turn_left", "turn_right", "move_forwards", "move_backwards", "move_left", "move_right"]
	
var step_distance = 2.0

var moving : bool = false
var rotating : bool = false
var rotation_lerp : float = 0.0
var rotation_speed : float = 4.0

var in_melee_combat : bool = false
var action_queue : Array = []
var tween_duration = 0.25

@onready var hud = $HUD

var last_polling_time : int = 0
var polling_interval : int = 250 # msec


signal died
signal finished_level
signal started_moving
signal finished_moving

func _enter_tree():
	Global.player = self
	$movetimer.set_wait_time(tween_duration + 0.05)


func _process(delta):
	
	if rotating:
		rotation_lerp += rotation_speed * delta
		if rotation_lerp > 1.0:
			rotation_lerp = 1.0

		var prevRot = prev_direction * 0.5 * PI
		var desiredRot = direction * 0.5 * PI
		rotation.y = lerp_angle(prevRot, desiredRot, rotation_lerp )
		if rotation_lerp == 1.0:
			rotating = false
			rotation_lerp = 0.0
		

func _unhandled_input(_event):
	if in_melee_combat: # no moving until combat is resolved
		return
		
	for actionName in actions_to_queue:
		if Input.is_action_just_pressed(actionName):
			if action_queue.size() == 0 and $movetimer.is_stopped():
				take_action(actionName)
			else:
				action_queue.push_back(actionName)

	if Input.is_action_just_pressed("switch_camera"):
		if !$OverheadCam.current:
			$OverheadCam.current = true
		else:
			$Camera3D.current = true


func change_direction(action_name):
	if !rotating:
		if action_name == "turn_left":
			prev_direction = direction
			direction += 1
		elif action_name == "turn_right":
			prev_direction = direction
			direction -= 1
		#direction = direction % 4 # wrap to 0 # not needed.. causes rotating artifact when it loops.

		rotating = true
		


func take_action(action_name):
	var raycasts = {
		"move_forwards":$Raycasts/forwardRayCast3D,
		"move_backwards":$Raycasts/backwardRayCast3D,
		"move_left":$Raycasts/LeftRayCast3D2,
		"move_right":$Raycasts/RightRayCast3D3,
	}
	
	if Global.user_prefs["move_instantly"] == false:
		$movetimer.start()
	
	if action_name in ["turn_left", "turn_right"]:
		change_direction(action_name)
	elif action_name == "move_forwards":
		if !raycasts[action_name].is_colliding():
			move(action_name)
		else:
			var possible_robot = raycasts[action_name].get_collider()
			if is_instance_valid(possible_robot) and "robot" in possible_robot.name.to_lower():
				var robot = possible_robot
				if robot.get("requires_persuasion") == true:
					initiate_melee_combat(robot)
				else:
					initiate_monologue(robot)

	elif action_name in ["move_backwards", "move_left", "move_right"]:
		# don't initiate combat unless you're facing the enemy
		# but you walls and robots still block you
		if !raycasts[action_name].is_colliding():
			move(action_name)
		else:
			print(action_name , " is colliding with ", raycasts[action_name].get_collider().name)
			


func move(action_name):
	var actionRot : float # matches keystroke
	var actions = [ "move_forwards", "move_left", "move_backwards", "move_right"]
	actionRot = (0.5*PI) * actions.find(action_name) # 1/2Pi = 90deg

	var forwardAxis = -self.get_transform().basis.z

	if Global.user_prefs["move_instantly"] == true:
		$SingleFootstepNoise.start()
	else:
		$FootstepsNoise.start()
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("_on_player_finished_moving"):
			enemy._on_player_finished_moving()

	var dirVector = (forwardAxis * step_distance).rotated(Vector3.UP, actionRot)
	
	if Global.user_prefs["move_instantly"] == true:
		#original movement: 
		self.position += dirVector
	else:
		var tween = self.create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		#tween.set_trans(Tween.TRANS_CUBIC)
		
		tween.tween_property(self, "position", position + (dirVector), tween_duration)



func take_damage(_damage): # for Beanie
	# This is handled in hud
	pass

func initiate_monologue(robot):
	$HUD.initiate_monologue(robot)

func initiate_melee_combat(robot):
	in_melee_combat = true
	$HUD.initiate_melee_combat(robot)

func _on_melee_combat_resolved(robot):
	if is_instance_valid(robot):
		robot.die()
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

func relocate_to_center_of_square():
	# This shouldn't be necessary..
	# attempt to solve bug where player sometimes ends up out of position
	global_position.x = snapped(global_position.x, 2.0)
	global_position.y = snapped(global_position.y, 2.0)


func _on_movetimer_timeout():
	if action_queue.size() > 0:
		take_action(action_queue.pop_front())
	else:
		var key_held :bool = false
		for action_name in ["move_forwards", "move_backwards", "move_left", "move_right"]:
			# for turning, player has to press manually each 90deg unit.
			if Input.is_action_pressed(action_name):
				key_held = true
				if !Global.user_prefs["move_instantly"]:
					$movetimer.start()
				take_action(action_name)

		if !key_held:
			relocate_to_center_of_square()
