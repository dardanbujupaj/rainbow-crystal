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


func _on_StompTimer_timeout() -> void:
	state_machine.travel("stomp")
