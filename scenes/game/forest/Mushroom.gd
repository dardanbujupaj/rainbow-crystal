extends KinematicBody2D


var direction = sign(rand_range(-1, 1))
const SPEED = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collider = $RayCast2D.get_collider()
	if collider is Character:
		collider.hit(1, Vector2(direction, 0))
	if collider != null:
		direction *= -1
		scale.x *= -1
	move_and_slide(Vector2(direction * SPEED, 10), Vector2.UP)
