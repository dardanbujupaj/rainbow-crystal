extends CenterContainer



onready var list = $PanelContainer/VBoxContainer/Songs


# Called when the node enters the scene tree for the first time.
func _ready():
	for song in MusicEngine.songs.keys():
		list.add_item(song)


func play(song: String):
	MusicEngine.play_song(song)


func _on_Close_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")


func _on_Songs_item_activated(index: int) -> void:
	play(list.get_item_text(index))
