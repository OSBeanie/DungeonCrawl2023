extends Control

@export var next_scene : PackedScene

@onready var tab_container = %TabContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_rewind_dialog_button_pressed():
	if tab_container.current_tab > 0:
		tab_container.current_tab -= 1

	
func _unhandled_input(_event):
	var fwd_actions = ["ui_accept", "ui_right", "ui_cancel"]
	var already_captured : bool = false
	for actionName in fwd_actions:
		if Input.is_action_just_pressed(actionName) and !already_captured:
			already_captured = true
			_on_advance_dialog_button_pressed()
	if !already_captured and Input.is_action_just_pressed("ui_left"):
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


	
func hide_advance_button():
	$VBoxContainer/MarginContainer2/HBoxContainer/AdvanceDialogButton.hide()

func show_advance_button():
	$VBoxContainer/MarginContainer2/HBoxContainer/AdvanceDialogButton.show()

func hide_rewind_button():
	$VBoxContainer/MarginContainer2/HBoxContainer/RewindDialogButton.hide()
	
func show_rewind_button():
	$VBoxContainer/MarginContainer2/HBoxContainer/RewindDialogButton.show()

func _on_tab_container_tab_changed(tab):
	var textbox = tab_container.get_child(tab)
	if textbox.has_method("reset"):
		textbox.reset()
	if tab == tab_container.get_child_count():
		hide_advance_button()
	else:
		show_advance_button()
	
	if tab == 0:
		hide_rewind_button()
	else:
		show_rewind_button()
