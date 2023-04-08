extends "res://GUI/Menus/campaign_text_crawl.gd"

@export_multiline var good_ending
@export_multiline var evil_ending
@export_multiline var lose_ending
@export_multiline var escape_ending

# Called when the node enters the scene tree for the first time.
func _ready():
	var title = $VBoxContainer/EndingTitleLabel
	var dynamic_textbox = $VBoxContainer/MarginContainer/TabContainer/Chapter3
	
	if Global.exit_found == true:
		title.text = "Ending 1/4: Escape"
		dynamic_textbox.text = escape_ending
	elif Global.player_stats["Health"] == 0:
		title.text = "Enging 2/4: Bad"
		dynamic_textbox.text = lose_ending
	elif Global.player_stats["Seraph"] > Global.player_stats["Siann"]:
		title.text = "Ending 3/4: Aligned"
		dynamic_textbox.text = good_ending
	else:
		title.text = "Ending 4/4: Misaligned"
		dynamic_textbox.text = evil_ending
	



