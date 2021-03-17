extends Node2D


onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree["parameters/playback"]




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(2), "timeout")
	state_machine.travel("activate")
	$Timer.start(5)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func creak() -> void:
	SoundEngine.play_sound("EntCreak")


func impact(amount: float) -> void:
	SoundEngine.play_sound("EntImpact")
	get_tree().call_group("cameras", "add_trauma", amount)


func start_combat():
	$CanvasLayer/MarginContainer.show()
	MusicEngine.play_song("Showdown")


func spawn_acorn(position: Vector2 = Vector2()):
	var instance = preload("res://scenes/game/forest/ent/acorn/Acorn.tscn").instance()
	instance.position = position
	instance.set_as_toplevel(true)
	add_child(instance)
	

func spawn_acorn_salve():
	for i in range(-5, 5):
		yield(get_tree().create_timer(0.5), "timeout")
		spawn_acorn(Vector2(50 * i, -200))


func _on_StompTimer_timeout() -> void:
	state_machine.travel("stomp")
	spawn_acorn_salve()
