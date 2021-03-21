extends Control

signal next_step

"""
class Signal:
	var target: Node
	var signal: String


class DialogStep:
	var text_key: String
	var speaker: String
	var end_trigger: Signal
	var end_hook: FuncRef
"""


var step_queue = []
var current_step = null
var characters_left: int = 0


onready var label = $MarginContainer/RichTextLabel


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("g_interact"):
		if characters_left == 0:
			emit_signal("next_step")
		else:
			characters_left = 0


func _process(delta: float) -> void:
	render_current_step()
	

func queue_step(step) -> void:
	step_queue.append(step)
	if current_step == null:
		next_step()


func next_step() -> void:
	show()
	var step = step_queue.pop_front()
	
	if step != null:
		current_step = step
		characters_left = len(get_text(step))
		
		render_current_step()
		
		if step.has("end_trigger"):
			print(step)
			yield(step["end_trigger"]["target"], step["end_trigger"]["signal"])
		else:
			yield(self, "next_step")
			
		current_step = null
		if step.has("end_hook"):
			step["end_hook"].call_func()
		
		call_deferred("next_step") # I think this is a good idea for the call stack?
	else:
		hide()


func get_text(step) -> String:
	if step.has("variables"):
		return tr(step.text_key) % step["variables"]
	else:
		return tr(step.text_key)


func render_current_step():
	if current_step:
		var text = get_text(current_step)
		
		var content = text.substr(0, len(text) - characters_left)
		
		if not current_step.has("end_trigger"):
			content += "\n\n"
			content += tr("DIALOG_CONTINUE_DIALOG") % Keymap.input_to_text(Keymap.input_for_action("g_interact"))
		
		if current_step.has("speaker"):
			content = "%s: %s" % [tr(current_step.speaker), content]
			label.bbcode_text = content
		else:
			content = "[color=#cccccc]%s[/color]" % [content]
			label.bbcode_text = content


func _on_CharacterTimer_timeout() -> void:
	if characters_left > 0:
		characters_left -= 1
