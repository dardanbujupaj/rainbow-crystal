extends Node2D


const background_color = Color("4da6ff")

onready var dialog = $CanvasLayer/Dialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicEngine.play_song("Crystals")
	
	for color in Orb.OrbColor.values():
		var orb = preload("res://scenes/game/orb/Orb.tscn").instance()
		orb.color = color
		orb.attach_to_node($Crystal)
	
	if SaveGame.shards_disappeared:
		setup_dialogs()


func setup_dialogs():
	$Character.moving_disabled = true
	dialog.queue_step({
		"text_key": "DIALOG_VILLAGE_",
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_INTRO_2"
	})
	dialog.queue_step({
		"text_key": "DIALOG_TUTORIAL_ELDEST_APPLES",
		"speaker": "Old person"
	})

func set_red_disabled():
	get_parent()._set_color_enabled(false, "red")
	pass


func set_green_disabled():
	get_parent()._set_color_enabled(false, "green")
	pass


func set_blue_disabled():
	get_parent()._set_color_enabled(false, "blue")
	pass
	
	
func orb_sound():
	SoundEngine.play_sound("OrbWhoosh")


func _on_Area2D_body_entered(body: Node) -> void:
	MusicEngine.play_song("Runaway")
	var state_machine = $AnimationTree["parameters/playback"]
	# state_machine.travel("orbs_disappearing")
		
