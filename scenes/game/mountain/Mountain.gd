extends Node2D

const background_color = Color("272736")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicEngine.play_song("Apocalypse")
	
	$Node2D/Orb.attach_to_node($Node2D)
	$Node2D/Orb.collectible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
