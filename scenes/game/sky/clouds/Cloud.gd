extends StaticBody2D



onready var tween = $Tween
onready var sprite = $clouds


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func impact(direction: Vector2, impact_position = global_position) -> void:
	direction = direction.normalized()
	tween.stop_all()
	tween.interpolate_property(sprite, "position", sprite.position, sprite.position + direction * 5, 0.05, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(sprite, "position", sprite.position + direction * 5, Vector2(), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.05)
	
	tween.interpolate_property(sprite, "scale", sprite.scale, Vector2(1.1, 0.9), 0.05, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "scale", Vector2(1.1, 0.9), Vector2(1, 1), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.05)
	tween.start()
	
	$CPUParticles2D.position = to_local(impact_position)
	$CPUParticles2D.direction = direction
	$CPUParticles2D.emitting = true
