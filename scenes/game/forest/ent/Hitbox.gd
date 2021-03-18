extends Area2D

signal hit(damage, impact)


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called by source, when character gets hit
# decrease health and show impact
func hit(damage: float, direction: Vector2):
	emit_signal("hit", damage, direction)
