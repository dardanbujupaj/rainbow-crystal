extends CenterContainer


const test_scenes = {
	"Play": "res://scenes/game/Game.tscn",
	"Key Mapping": "res://scenes/key_remapping/KeyRemapping.tscn",
	"Music Player": "res://scenes/music_player/MusicPlayer.tscn",
	"Settings": "res://scenes/settings_menu/SettingsMenu.tscn",
	"Credits": "res://scenes/credits/Credits.tscn"
}	



# Called when the node enters the scene tree for the first time.
func _ready():
	for scene in test_scenes:
		var button = Button.new()
		button.text = scene
		button.connect("pressed", self, "_goto_scene", [test_scenes[scene]])
		
		$VBoxContainer/Scenes.add_child(button)



func _goto_scene(path: String) -> void:
	SceneLoader.goto_scene(path)


func _on_Button_pressed() -> void:
	get_tree().quit()
