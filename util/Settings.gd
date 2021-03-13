extends "res://util/PersistentProperties.gd"


var main_volume: float = 1 setget _set_main_volume
var sound_volume: float = 1 setget _set_sound_volume
var music_volume: float = 1 setget _set_music_volume

var screenshake_intensity: float = 1.0
var particles_enabled: bool = true

var language: String setget _set_language, _get_language



func _init():
	# override filename
	filepath = 'user://settings.json'


# set soundeffect volume on AudioServer
func _set_sound_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sound"),
		linear2db(new_value)
	)
	sound_volume = new_value

# set music volume on AudioServer
func _set_music_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		linear2db(new_value)
	)
	music_volume = new_value

# set master volume on AudioServer
func _set_main_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear2db(new_value)
	)
	main_volume = new_value


func _set_language(new_language: String) -> void:
	TranslationServer.set_locale(new_language)
	language = new_language


func _get_language() -> String:
	return TranslationServer.get_locale().split("_")[0]
