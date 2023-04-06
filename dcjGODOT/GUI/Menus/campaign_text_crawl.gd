extends Control

@export var next_scene : PackedScene

@onready var tab_container = %TabContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rewind_dialog_button_pressed():
	if tab_container.current_tab > 0:
		tab_container.current_tab -= 1

	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_right"):
		_on_advance_dialog_button_pressed()
	elif Input.is_action_just_pressed("ui_left"):
		_on_rewind_dialog_button_pressed()

func _on_advance_dialog_button_pressed():

	var tab = tab_container.get_child(tab_container.current_tab)
	if tab.get("full_reveal") == true:
		var next_tab_idx = tab_container.current_tab + 1
		if next_tab_idx == tab_container.get_child_count():
			if next_scene != null:
				StageManager.change_scene_to_packed(next_scene)	
		else:
			tab_container.current_tab = next_tab_idx
	
	
	else:
		if tab.has_method("reveal_all_text"):
			tab.reveal_all_text()


	
