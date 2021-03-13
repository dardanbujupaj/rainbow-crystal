extends HBoxContainer

signal action_input

var action: String


func _input(event: InputEvent):
	
	if can_map_event(event):
		emit_signal("action_input", event)


func can_map_event(event: InputEvent):
	# some events can't be mapped to actions
	if not event.is_action_type():
		return false
	# wait for button release (this allows for key modifiers)
	if event.is_pressed():
		return false
	if event is InputEventJoypadMotion:
		return abs((event as InputEventJoypadMotion).axis_value) > 0.3
	
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = action
	update_button()

	

func update_button():
	if len(InputMap.get_action_list(action)) > 0:
		$Button.text = (InputMap.get_action_list(action)[0] as InputEvent).as_text()
	else:
		$Button.text = "..."

func change_event():
	$Button.text = "..."
	var event = yield(self, "action_input")
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	update_button()
	get_tree().set_input_as_handled()


func _on_Button_pressed():
	change_event()
