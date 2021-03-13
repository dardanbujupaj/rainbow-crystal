extends Node

const POOL_SIZE = 8

const sounds = {
	
#	"MenuButtonSound": {
#		"stream": preload("res://Sounds/MenuButtonSound.wav"),
#		"volume": 0
#		},
#	"MoonImpact": {
#		"stream": preload("res://Sounds/MoonImpact.wav"),
#		"volume": 0
#		},
#	"AstroidImpact": {
#		"stream": preload("res://Sounds/AstroidImpact.wav"),
#		"volume": -3
#		},
#	"Wurmhole": {
#		"stream":preload("res://Sounds/wurmhole.wav"),
#		"volume": 0
#		},
#	"Reset": {
#		"stream": preload("res://Sounds/Reset.wav"),
#		"volume": 0
#		},
#	"Star": {
#		"stream": preload("res://Sounds/Star.wav"),
#		"volume": 0
#		},
#	"MoonThrowing": {
#		"stream": preload("res://Sounds/MoonThrowing.wav"),
#		"volume": 0
#		},
#	"MenuButtonHoverSound": {
#		"stream": preload("res://Sounds/MenuButtonHoverSound.wav"),
#		"volume": -18
#		},
#	"Mars1": {
#		"stream": preload("res://Sounds/Mars1.wav"),
#		"volume": 0
#		},
#	"Mars2": {
#		"stream": preload("res://Sounds/Mars2.wav"),
#		"volume": 0
#		},
#	"Jupiter": {
#		"stream": preload("res://Sounds/Jupiter1.wav"),
#		"volume": 0
#		},
#	"Whoosh": {
#		"stream": preload("res://Sounds/woosh.wav"),
#		"volume": 20
#		},
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = "Sound"
		add_child(player)


func _get_idle_player():
	for player in get_children():
		if not (player as AudioStreamPlayer).playing:
			return player

func play_sound(sound_name: String):
	var audio_player: AudioStreamPlayer = _get_idle_player()
	if audio_player != null:
		var sound = sounds[sound_name]
		audio_player.stream = sound["stream"]
		audio_player.volume_db = sound["volume"]
		audio_player.play()
