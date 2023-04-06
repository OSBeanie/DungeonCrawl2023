extends "res://GUI/Menus/campaign_text_crawl.gd"

@export_multiline var good_ending
@export_multiline var evil_ending
@export_multiline var lose_ending

# Called when the node enters the scene tree for the first time.
func _ready():
	var dynamic_textbox = $VBoxContainer/MarginContainer/TabContainer/Chapter3
	if Global.player_stats["Health"] == 0:
		dynamic_textbox.text = lose_ending
	elif Global.player_stats["Seraph"] > Global.player_stats["Siann"]:
		dynamic_textbox.text = good_ending
	else:
		dynamic_textbox.text = evil_ending
	


func _on_quit_button_pressed():
	get_tree().quit()
