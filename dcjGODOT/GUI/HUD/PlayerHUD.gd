extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	update()


func initiate_melee_combat():
	$CombatDialogue.reset_timer()
	$CombatDialogue.show()
	$CombatDialogue.generate_dialog()

func update():
	%SeraphProgress.value = Global.player_stats["Seraph"]
	%SianProgress.value = Global.player_stats["Siann"]
	print("Seraph ", Global.player_stats["Seraph"])
	print("Siann ", Global.player_stats["Siann"])
