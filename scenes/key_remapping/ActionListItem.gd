extends HBoxContainer

# this signal is emitted when an event is pressed which can be mapped to an action
signal action_input

# action to represent for this list-item
var action: String

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


# Called when the node enters the scene tree for the first time.
func _ready():
	$ActionLabel.text = action
	update_button()


# called everytime any input is registered
func _input(event: InputEvent):
	# check if input can be mapped to action
	if can_map_event(event):
		# if so emit the action input signal wich will be catched by yield in "remap_event"
		emit_signal("action_input", event)


# Check if event is mappable 
# (e.g. an actual keypress, joypad input or mouse click)
func can_map_event(event: InputEvent):
	# some events can't be mapped to actions
	if not event.is_action_type():
		return false
		
	# wait for button release (this allows for key modifiers)
	if event.is_pressed():
		return false
	
	# threshold for JoyPad-Axis 
	if event is InputEventJoypadMotion:
		return abs((event as InputEventJoypadMotion).axis_value) > 0.3
	
	return true


# update the button text in this list-item
func update_button():
	if len(InputMap.get_action_list(action)) > 0:
		$Event.text = input_to_text(InputMap.get_action_list(action)[0])
	else:
		$Event.text = "NOT_AVAILABLE"


func input_to_text(input: InputEvent) -> String:
	if input is InputEventMouseButton:
		return MouseButtons[input.button_index]
		
	if input is InputEventJoypadButton:
		return "Joypad Button %d" % input.button_index
		
	if input is InputEventJoypadMotion:
		return "Joypad Axis %d%s" % [input.axis, "+" if input.axis_value > 0 else "-"]
	
	return input.as_text()



# Procedure to change the event for this action
func remap_event():
	# show the user that we're waiting for input
	$Event.text = "..."
	
	# wait for an appropriate input to happen
	var event = yield(self, "action_input")
	
	# remove existing actions
	InputMap.action_erase_events(action)
	
	# add the new action
	InputMap.action_add_event(action, event)
	
	# update the text in the button
	update_button()
	
	# make sure the input won't be handled any further
	if not event is InputEventMouseButton:
		get_tree().set_input_as_handled()


func _on_Event_pressed():
	remap_event()
