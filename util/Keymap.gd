extends "res://util/PersistentProperties.gd"

var _keymap: Dictionary = _get_keymap() setget _set_keymap, _get_keymap


const MouseButtons = {
	1: "BUTTON_LEFT", # Left mouse button.
	2: "BUTTON_RIGHT", # Right mouse button.
	3: "BUTTON_MIDDLE", # Middle mouse button.
	8: "BUTTON_XBUTTON1", # Extra mouse button 1 (only present on some mice).
	9: "BUTTON_XBUTTON2", # Extra mouse button 2 (only present on some mice).
	4: "BUTTON_WHEEL_UP", # Mouse wheel up.
	5: "BUTTON_WHEEL_DOWN", # Mouse wheel down.
	6: "BUTTON_WHEEL_LEFT", # Mouse wheel left button (only present on some mice).
	7: "BUTTON_WHEEL_RIGHT"
}


func _init():
	# override filename
	filepath = 'user://keymap.dat'
	storage_type = 'dat'
	
	
func input_to_text(input: InputEvent) -> String:
	if input is InputEventMouseButton:
		return MouseButtons[input.button_index]
		
	if input is InputEventJoypadButton:
		return "Joypad Button %d" % input.button_index
		
	if input is InputEventJoypadMotion:
		return "Joypad Axis %d%s" % [input.axis, "+" if input.axis_value > 0 else "-"]
	
	return input.as_text()


func input_for_action(action: String) -> InputEvent:
	if len(InputMap.get_action_list(action)) > 0:
		return InputMap.get_action_list(action)[0]
	else:
		return null

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
	
