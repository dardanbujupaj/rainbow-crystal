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
	
	var orb_containers = [$Orbs/Node2D, $Orbs/Node2D2, $Orbs/Node2D3]
	
	for node in orb_containers:
		var orb = node.get_node("Orb")
		orb.attach_to_node(node)
		orb.connect("mouse_entered", self, "_on_Orb_mouse_entered", [node])
	
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


func _on_Orb_mouse_entered(orb) -> void:
	SoundEngine.play_sound("OrbWhoosh")
	orb.position.x = rand_range(0, rect_size.x)
	orb.position.y = rand_range(0, rect_size.y)
