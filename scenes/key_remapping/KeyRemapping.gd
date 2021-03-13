extends CenterContainer


onready var action_list = $PanelContainer/VBoxContainer2/ActionList


# Called when the node enters the scene tree
func _ready():
	init_action_list()


func init_action_list():
	var actions = InputMap.get_actions()
	actions.sort()
	
	for action in actions:
		var item = preload("./ActionListItem.tscn").instance()
		item.action = action
		action_list.add_child(item)


func _on_Button_pressed():
	InputMap.load_from_globals()
	for list_item in action_list.get_children():
		list_item.update_button()


func _on_Close_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
