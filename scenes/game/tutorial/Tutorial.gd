extends Node2D


onready var dialog = $CanvasLayer/Dialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicEngine.play_song("Runaway")
	
	dialog.queue_step({
		"text_key": "The habitants of Prism, your home village, are in midst of the preparations for the festival of the crystal.",
	})
	dialog.queue_step({
		"text_key": "You’ve been assigned to collect the apples with one of the village eldest."
	})
	dialog.queue_step({
		"text_key": "Oy, hurry up. We need to collect those apples for the festival of the crystal!",
		"speaker": "Old person"
	})

