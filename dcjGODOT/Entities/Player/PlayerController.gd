extends Node3D
var direction = 0
var directions = ["N", "W", "S", "E"]
var step_distance = 2.0

var moving = false
var in_melee_combat : bool = false
var action_queue : Array = []
@onready var hud = $HUD

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
		
	var actions_to_queue = ["turn_left", "turn_right", "move_forwards", "move_backwards", "move_left", "move_right"]
	for actionName in actions_to_queue:
		if Input.is_action_just_pressed(actionName):
			if action_queue.size() == 0 and $movetimer.is_stopped():
				take_action(actionName)
			else:
				action_queue.push_back(actionName)


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
		var duration = 0.15
		tween.tween_property(self, "rotation_degrees", Vector3(0,direction * 90,0), duration)


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
	if action_name == "move_forwards":
		actionRot = 0.0
	elif action_name == "move_right":
		actionRot = -0.5*PI
	elif action_name == "move_backwards":
		actionRot = PI
	elif action_name == "move_left":
		actionRot = -1.5*PI

	var forwardAxis = -self.get_transform().basis.z
		
#	var move_dir = 1
#	if action_name == "move_backwards":
#		move_dir = -1
	
	if Global.user_prefs["move_instantly"] == true:
		$SingleFootstepNoise.start()
	else:
		$FootstepsNoise.start()
	#separate method: get_parent().get_node("movetimer").start()
	
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
		tween.set_ease(Tween.EASE_OUT)
		#tween.set_trans(Tween.TRANS_CUBIC)
		
		tween.tween_property(self, "position", position + (dirVector*0.75)+Vector3(0,0.1,0), 0.15)
		tween.tween_property(self, "position", position + (dirVector), 0.1)
#		tween.parallel().tween_property(self, "rotation", Vector3(-0.03,0,0), 0.1).as_relative()
#		tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1).from_current().as_relative()
#


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



func _on_movetimer_timeout():
	if action_queue.size() > 0:
		take_action(action_queue.pop_front())
