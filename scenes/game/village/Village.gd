extends Node2D


const background_color = Color(0.294118, 0.356863, 0.670588)

onready var dialog = $CanvasLayer/Dialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicEngine.play_song("Crystals")
	
	
	if SaveGame.orbs_disappeared:
		for orb in $Crystal.get_children():
			orb.queue_free()
	else:
		setup_dialogs()


func setup_dialogs():
	$Character.moving_disabled = true
	
	dialog.queue_step({
		"text_key": "DIALOG_VILLAGE_ELDEST_CRYSTAL",
		"speaker": "ELDEST",
		"end_hook": funcref(self, "animate_orbs_disappearing"),
	})
	


func set_red_disabled():
	get_parent()._set_color_enabled(false, "red")
	pass


func orbs_disappeared():
	SaveGame.orbs_disappeared = true
	$Character.moving_disabled = false
	
	
	dialog.queue_step({
		"text_key": "DIALOG_VILLAGE_ELDEST_ORBS_COLLECT",
		"speaker": "ELDEST"
	})
	dialog.queue_step({
		"text_key": "DIALOG_VILLAGE_ELDEST_ORBS_ORIGIN",
		"speaker": "ELDEST"
	})


func set_green_disabled():
	get_parent()._set_color_enabled(false, "green")
	pass


func set_blue_disabled():
	get_parent()._set_color_enabled(false, "blue")
	pass
	
	
func orb_sound():
	SoundEngine.play_sound("OrbWhoosh")


func animate_orbs_disappearing() -> void:
	# MusicEngine.play_song("Runaway")
	$AnimationPlayer.play("orbs_disappearing")
		
