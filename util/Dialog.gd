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
		characters_left = len(step["text_key"])
		
		render_current_step()
		
		if step.has("end_trigger"):
			yield(step["end_trigger"]["target"], step["end_trigger"]["signal"])
		else:
			yield(self, "next_step")
			
		current_step = null
		if step.has("end_hook"):
			step["end_hook"].call_func()
		
		call_deferred("next_step") # I think this is a good idea for the call stack?
	else:
		hide()


func render_current_step():
	if current_step:
		var content = current_step.text_key.substr(0, len(current_step.text_key) - characters_left)
		
		if current_step.has("speaker"):
			content = "%s: %s" % [current_step.speaker, content]
			label.bbcode_text = content
		else:
			content = "[color=#cccccc]%s[/color]" % [content]
			label.bbcode_text = content


func _on_CharacterTimer_timeout() -> void:
	if characters_left > 0:
		characters_left -= 1
