extends Node2D





# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	call_deferred("start_sound")
	pass # Replace with function body.

func start_sound():
	yield(get_tree().create_timer(2), "timeout")
	# MusicEngine.play_song("Crystals")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
