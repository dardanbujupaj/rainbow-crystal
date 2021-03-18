extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicEngine.play_song("Apocalypse")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
