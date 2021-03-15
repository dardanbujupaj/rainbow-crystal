extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_red_disabled():
	get_parent()._set_color_enabled(false, "red")
	pass
func set_green_disabled():
	get_parent()._set_color_enabled(false, "green")
	pass
func set_blue_disabled():
	get_parent()._set_color_enabled(false, "blue")
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body == $Character:
		var state_machine = $AnimationTree["parameters/playback"]
		state_machine.travel("orbs_disappearing")
		
