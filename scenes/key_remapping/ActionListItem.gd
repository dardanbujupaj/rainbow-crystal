extends HBoxContainer

# this signal is emitted when an event is pressed which can be mapped to an action
signal action_input

# action to represent for this list-item
var action: String



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
	var event = Keymap.input_for_action(action)
	if event:
		$Event.text = Keymap.input_to_text(event)
	else:
		$Event.text = "NOT_AVAILABLE"


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
