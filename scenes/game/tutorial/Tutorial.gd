extends Node2D

signal two_apples_collected
signal four_apples_collected


onready var dialog = $CanvasLayer/Dialog


var apples = 0 setget _set_apples


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicEngine.play_song("Runaway")
	setup_dialogs()


func walk_tutorial_done():
	$eldest.scale.x = 1
	$Apple3.monitoring = true
	$Apple4.monitoring = true


func tutorial_done():
	$VillagePortal.monitoring = true
	$VillagePortal.show()
	SaveGame.tutorial_completed = true


func setup_dialogs():
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_INTRO_1",
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_INTRO_2"
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_ELDEST_APPLES",
		"speaker": "Old person"
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_ELDEST_WALK",
		"speaker": "Old person"
	})
	
	var walk_inputs = [
		Keymap.input_to_text(Keymap.input_for_action("g_left")),
		Keymap.input_to_text(Keymap.input_for_action("g_right"))
	]
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_WALK",
		"variables": walk_inputs,
		"end_trigger": {
			"target": self,
			"signal": "two_apples_collected"
		}
	})
	
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_ELDEST_TREE",
		"speaker": "Old person"
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_ELDEST_JUMP",
		"speaker": "Old person",
		"end_hook": funcref(self, "walk_tutorial_done")
	})
	
	var inputs = [
		Keymap.input_to_text(Keymap.input_for_action("g_jump"))
	]
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_JUMP",
		"variables": inputs,
		"end_trigger": {
			"target": self,
			"signal": "four_apples_collected"
		}
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_ELDEST_DONE",
		"speaker": "Old person",
		"end_hook": funcref(self, "tutorial_done")
	})


func _set_apples(new_apples: int) -> void:
	if new_apples >= 2 and apples < 2:
		emit_signal("two_apples_collected")
	if new_apples >= 4 and apples < 4:
		emit_signal("four_apples_collected")
	apples = new_apples
