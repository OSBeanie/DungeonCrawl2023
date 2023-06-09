extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$SettingsButton/PopupMenu.hide()
	update()
	
func initiate_monologue(robot):
	var combat = $CombatDialogue
	combat.robot = robot
	combat.win()
	

func initiate_melee_combat(robot):
	var combat = $CombatDialogue
	combat.robot = robot
	combat.reset_timer()
	combat.show()
	combat.generate_dialog()

func update():
	var seraph = Global.player_stats["Seraph"]
	var siann = Global.player_stats["Siann"]
	var health = Global.player_stats["Health"]
	%SeraphProgress.value = seraph
	%SianProgress.value = siann
	%HealthProgress.value = health

	if seraph >= 100 or siann >= 100:
		end_game()
	elif health <= 0:
		end_game()

#	print("Seraph ", Global.player_stats["Seraph"])
#	print("Siann ", Global.player_stats["Siann"])

func end_game():
	StageManager.change_scene_to_file("res://GUI/Menus/exit_scene.tscn")


func _on_settings_button_pressed():
	$SettingsButton/PopupMenu.popup_centered_ratio(0.5)
	$SettingsButton/PopupMenu/CenterContainer/Settings/CloseMenuButton.grab_focus()

func _on_close_menu_button_pressed():
	$SettingsButton/PopupMenu.hide()
