extends CenterContainer


onready var action_list = $PanelContainer/VBoxContainer2/ScrollContainer/ActionList


# Called when the node enters the scene tree
func _ready():
	init_action_list()


# Read all actions from the Input map and create a list item for each
func init_action_list():
	var actions = InputMap.get_actions()
	# sort by action name
	actions.sort()
	
	for action in actions:
		var item = preload("./ActionListItem.tscn").instance()
		item.action = action
		action_list.add_child(item)


# Set all Actions to default mapping (from project settings)
func _on_Reset_pressed() -> void:
	InputMap.load_from_globals()
	
	# update all buttons
	for list_item in action_list.get_children():
		list_item.update_button()


func _on_Close_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")


