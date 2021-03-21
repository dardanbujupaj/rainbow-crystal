extends Node2D

const background_color = Color("4da6ff")

var start_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = $Character.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if $Character.position.y > 0:
		$Character.position = start_pos
