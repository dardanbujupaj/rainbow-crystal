extends Area2D


var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_toplevel(true)
	SoundEngine.play_sound("SlingshotShoot")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += 98 * delta
	position += velocity * delta


func _on_hit_target(target: Node) -> void:
	if target.has_method("hit"):
		target.hit(1, velocity.normalized())
		SoundEngine.play_sound("CharacterHit")
		queue_free()

