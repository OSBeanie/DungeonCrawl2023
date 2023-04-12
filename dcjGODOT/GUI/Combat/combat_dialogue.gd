"""
Melee combat is a dialogue between the player and the NPC.
The NPC states their perspective in one or two words,
The player must quickly choose a response from three options.

There's one best response, which converts the enemy to neutral.
One reponse will push the player toward Seraph (~good)
One response will push the player toward SIANN (~evil)

Combat continues until the enemy is converted to neutral,
and the player takes damage after each exchange.

"""

extends Control

@export var response_duration = 8.0
@onready var hud = get_parent()
@export var combat_damage : float = 5.0
@export var hit_damage : float = 10.0

var robot

var difficulty_modifiers = [1.0, 1.75, 3.0]

# might need to refine this list to make it more transparent and fair.
# antonym, synonym, tangentially related concept

# for each word, 3 possible responses are listed.
# response 0 = neutral, 1 = seraph, 2 = siann
enum response_types { NEUTRAL, SERAPH, SIANN }

var current_dialogue : Dictionary # Dictionary with a single row
var current_question : String


signal combat_resolved


# Called when the node enters the scene tree for the first time.
func _ready():
	$ConcessionPopup.hide()
	#generate_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	%ResponseTimerLabel.text = str(%ResponseTimer.time_left).pad_decimals(1)

func generate_dialog():
	if not combat_resolved.is_connected(Global.player._on_melee_combat_resolved):
		combat_resolved.connect(Global.player._on_melee_combat_resolved)
	$RobotNoise.start()
	
	current_dialogue = robot.get_node("WordList").get_random()
	current_question = current_dialogue.keys()[0]
	
	var responses = current_dialogue[current_question]
	var shuffled_responses = responses.duplicate()
	shuffled_responses.shuffle()
	
	for button in %PlayerResponseOptions.get_children():
		button.text = str(button.get_index() + 1) + ". " + shuffled_responses.pop_back()
		
		if not button.response_chosen.is_connected(self._on_response_chosen):
			button.response_chosen.connect(self._on_response_chosen)
	
	%EnemyText.text = current_question
	%ResponseTimer.set_wait_time(response_duration / difficulty_modifiers[Global.user_prefs["difficulty"]])
	%ResponseTimer.start()

func _on_response_chosen(responseString):
	var popup_text = load("res://GUI/Combat/damage_popup.tscn").instantiate()
	add_child(popup_text)
	
	# need to strip off the first 3 characters first.
	responseString = responseString.right(-3)
	
	var response_index = current_dialogue[current_question].find(responseString)
	#print(responseString + " = " + response_types.keys()[response_index])
	if response_index == response_types.SERAPH:
		Global.player_stats["Seraph"] += combat_damage * difficulty_modifiers[Global.user_prefs["difficulty"]]
		popup_text.popup("Seraph")
	elif response_index == response_types.SIANN:
		Global.player_stats["Siann"] += combat_damage * difficulty_modifiers[Global.user_prefs["difficulty"]]
		popup_text.popup("Siann")
	elif response_index == response_types.NEUTRAL:
		# convert/kill the NPC and end the encounter.
		win()
		return
	
	if hud.has_method("update"):
		hud.update()
	
	generate_dialog()

func win():
	hide()
	if robot != null and robot.dialog_text != "":
		$ConcessionPopup.set_dialog_text(robot)
		robot.die()
	elif robot != null and robot.dialog_text == "":
		$ConcessionPopup.reset_dialog_text()
	$ConcessionPopup.popup_centered_ratio(0.8)
	var timer = get_tree().create_timer(1.0)
	await timer.timeout
	$HappyNoise.start()
	%ResponseTimer.stop()
	%ResponseTimer.set_wait_time(response_duration)
	combat_resolved.emit(robot)
	



func _on_response_timer_timeout():
	hurt_player()

func hurt_player():
	# player didn't answer fast enough. take damage
	var popup_text = load("res://GUI/Combat/damage_popup.tscn").instantiate()
	add_child(popup_text)
	popup_text.popup("Health")
	$HurtNoise.start()
	Global.player_stats["Health"] -= hit_damage  * difficulty_modifiers[Global.user_prefs["difficulty"]]
	hud.update()

	%ResponseTimer.set_wait_time(response_duration)
	%ResponseTimer.start()
	
	
func reset_timer():
	%ResponseTimer.stop()
	%ResponseTimer.set_wait_time(response_duration)
	
