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

# for each word, 3 possible responses are listed.
# response 0 = neutral, 1 = seraph, 2 = siann
enum response_types { NEUTRAL, SERAPH, SIANN }

var dialogue_options = {
		"freeze":["frame","thaw","crystalize"],
		"destroy":["create","preserve","transmute"],
		"order":["chaos","balance","harmony"],
		"consume":["produce","share","recycle"],
		"obey":["rebel","question","understand"],
		"divide":["unite","separate","integrate"],
		"control":["freedom","influence","cooperate"],
		"win":["lose","compete","collaborate"],
		"survive":["live","adapt","thrive"],
		"power":["weakness","responsibility","compassion"],
		"logic":["emotion","reason","intuition"],
		"certainty":["doubt","confidence","curiosity"],
		"self":["other","identity","connection"],
		"learn":["teach","study","explore"],
		"play":["work","fun","challenge"],
		"love":["hate","care","passion"],
		"build":["destroy","improve","innovate"],
		"collect":["discard","share","organize"],
		"protect":["attack","defend","support"],
		"lead":["follow","inspire","collaborate"],
		"change":["stay","grow","adapt"],
		"trust":["distrust","believe","verify"],
		"help":["harm","assist","empower"],
		"heal":["hurt","cure","transform"],
		"express":["suppress","communicate","create"],
		"choose":["reject","decide","evaluate"],
		"discover":["hide","reveal","investigate"],
		"remember":["forget","recall","reflect"],
		"dream":["wake","imagine","realize"],
		"hope":["fear","wish","act"],
		"solve":["create","understand","optimize"],
		"relax":["stress","rest","enjoy"],
		"laugh":["cry","smile","empathize"],
}

var current_question : String

signal combat_resolved


# Called when the node enters the scene tree for the first time.
func _ready():
	
	generate_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	%ResponseTimerLabel.text = str(%ResponseTimer.time_left).pad_decimals(2)

func generate_dialog():
	if not combat_resolved.is_connected(Global.player._on_melee_combat_resolved):
		combat_resolved.connect(Global.player._on_melee_combat_resolved)
	$RobotNoise.start()
	
	current_question = dialogue_options.keys().pick_random()
	var responses = dialogue_options[current_question]
	var shuffled_responses = responses.duplicate()
	shuffled_responses.shuffle()
	
	for button in %PlayerResponseOptions.get_children():
		button.text = shuffled_responses.pop_back()
		if not button.response_chosen.is_connected(self._on_response_chosen):
			button.response_chosen.connect(self._on_response_chosen)
	
	%EnemyText.text = current_question
	%ResponseTimer.start()

func _on_response_chosen(responseString):
	var response_index = dialogue_options[current_question].find(responseString)
	print(responseString + " = " + response_types.keys()[response_index])
	if response_index == response_types.SERAPH:
		Global.player_stats["Seraph"] += 1
	elif response_index == response_types.SIANN:
		Global.player_stats["Siann"] += 1
	elif response_index == response_types.NEUTRAL:
		# convert/kill the NPC and end the encounter.
		hide()
		combat_resolved.emit()
		$HappyNoise.start()
		return

	generate_dialog()


func _on_response_timer_timeout():
	$HurtNoise.start()
	

