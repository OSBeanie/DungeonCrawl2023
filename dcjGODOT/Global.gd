extends Node

var player
var current_level

var exit_found : bool = false

enum difficulties { BEGINNER, INTERMEDIATE, ADVANCED }

var player_stats := {
	"Seraph" : 0,
	"Siann" : 0,
	"Health_Max" : 100,
	"Health" : 100,
	
}

@onready var default_player_stats := player_stats.duplicate()

var user_prefs = {
	"move_instantly":false,
	"difficulty":difficulties.BEGINNER
}


func reset_stats():
	player_stats = default_player_stats.duplicate()
