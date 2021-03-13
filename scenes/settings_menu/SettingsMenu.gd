extends CenterContainer

onready var particles = $PanelContainer/VBoxContainer/Particles/Particles
onready var screenshake = $PanelContainer/VBoxContainer/Screenshake/Screenshake
onready var sound = $PanelContainer/VBoxContainer/SoundVolume/Sound
onready var music = $PanelContainer/VBoxContainer/MusicVolume/Music
onready var main = $PanelContainer/VBoxContainer/MainVolume/Main
onready var language_selection = $PanelContainer/VBoxContainer/LanguageContainer/Language


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Settings.language)
	particles.pressed = Settings.particles_enabled
	screenshake.value = Settings.screenshake_intensity
	sound.value = Settings.sound_volume
	music.value = Settings.music_volume
	main.value = Settings.main_volume
	
	for language in TranslationServer.get_loaded_locales():
		language_selection.add_item(language, language.hash())
	language_selection.select(language_selection.get_item_index(Settings.language.hash()))
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Main_value_changed(value: float) -> void:
	Settings.main_volume = value


func _on_Sound_value_changed(value: float) -> void:
	Settings.sound_volume = value


func _on_Music_value_changed(value: float) -> void:
	Settings.music_volume = value
	

func _on_Screenshake_value_changed(value: float) -> void:
	Settings.screenshake_intensity = value


func _on_Particles_toggled(button_pressed: bool) -> void:
	Settings.particles_enabled = button_pressed



func _on_Close_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")


func _on_Language_item_selected(index: int) -> void:
	var language = language_selection.get_item_text(index)
	print(language)
	Settings.language = language
