extends Area2D


var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta
