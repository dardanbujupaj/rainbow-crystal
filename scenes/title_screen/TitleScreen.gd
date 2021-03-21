extends CenterContainer


const test_scenes = {
	"PLAY": "res://scenes/game/Game.tscn",
	"KEY_MAPPING": "res://scenes/key_remapping/KeyRemapping.tscn",
	#"MUSIC_PLAYER": "res://scenes/music_player/MusicPlayer.tscn",
	"SETTINGS": "res://scenes/settings_menu/SettingsMenu.tscn",
	"CREDITS": "res://scenes/credits/Credits.tscn"
}	



# Called when the node enters the scene tree for the first time.
func _ready():
	MusicEngine.play_song("Runaway")
	
	$Orbs/Node2D/Orb.attach_to_node($Orbs/Node2D)
	$Orbs/Node2D2/Orb2.attach_to_node($Orbs/Node2D2)
	$Orbs/Node2D3/Orb3.attach_to_node($Orbs/Node2D3)
	
	for scene in test_scenes:
		var button = Button.new()
		button.text = scene
		button.connect("pressed", self, "_goto_scene", [test_scenes[scene]])
		button.connect("pressed", self, "_on_Button_pressed")
		button.connect("mouse_entered", self, "_on_Button_mouse_entered")
		
		$PanelContainer/VBoxContainer/Scenes.add_child(button)



func _goto_scene(path: String) -> void:
	SceneLoader.goto_scene(path)


func _on_Button_pressed() -> void:
	SoundEngine.play_sound("UIClick")


func _on_Button_mouse_entered() -> void:
	SoundEngine.play_sound("UIHover")

func _on_Quit_pressed() -> void:
	get_tree().quit()
