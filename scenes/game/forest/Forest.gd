extends Node2D

const background_color = Color("323e4f")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VisualServer.set_default_clear_color("323e4f")
	MusicEngine.play_song("Awakening")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
