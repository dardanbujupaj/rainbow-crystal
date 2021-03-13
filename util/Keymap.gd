extends "res://util/PersistentProperties.gd"

var _keymap: Dictionary = _get_keymap() setget _set_keymap, _get_keymap


func _init():
	# override filename
	filepath = 'user://keymap.dat'
	storage_type = 'dat'


func _set_keymap(keymap: Dictionary) -> void:
	for action in keymap.keys():
		InputMap.action_erase_events(action)
		for event in keymap[action]:
			InputMap.action_add_event(action, event)
	
func _get_keymap() -> Dictionary:
	var keymap = {}
	
	for action in InputMap.get_actions():
		keymap[action] = InputMap.get_action_list(action)
	
	return keymap
	
