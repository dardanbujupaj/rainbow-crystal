extends Node

const POOL_SIZE = 8

const sounds = {
	
	"EntCreak": {
		"stream": preload("res://audio/effects/CREAK_Wood_Hollow_Deep_Smooth_mono.wav"),
		"volume": 0
		},
	"EntImpact": {
		"stream": preload("res://audio/effects/IMPACT_Generic_09_mono.wav"),
		"volume": 0
		},
	"UIHover": {
		"stream": preload("res://audio/effects/UI_Click_Metallic_mono.wav"),
		"volume": 0
		},
	"UIClick": {
		"stream":preload("res://audio/effects/UI_Click_Distinct_mono.wav"),
		"volume": 0
		},
	"AcornImpact": {
		"stream": preload("res://audio/effects/IMPACT_Wood_Plank_On_Wood_Pile_07_Short_mono.wav"),
		"volume": 0
		},
	"OrbWhoosh": {
		"stream": preload("res://audio/effects/WHOOSH_Whistle_Fast_01_mono.wav"),
		"volume": 0
		},
	"CharacterHit": {
		"stream": preload("res://audio/effects/THUD_Medium_01_mono.wav"),
		"volume": 0
		},
	"SlingshotShoot": {
		"stream": preload("res://audio/effects/WHOOSH_Air_Super_Fast_RR3_mono.wav"),
		"volume": 0
		},
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
