extends Area2D

var velocity: Vector2


onready var collision_tween = $CollisionTween


func _process(delta) -> void:
	rotation = velocity.angle() - PI / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += delta * 98
	position += velocity * delta
	


func _on_Acorn_body_entered(body: Node) -> void:
	var impact_direction = sign((body.position - position).x)
	(body as Character).hit(1, Vector2(impact_direction, 0))
	velocity.x = impact_direction * 10
	
	collision_tween.stop_all()
	collision_tween.interpolate_property(self, "modulate", modulate, Color.white * 5, 0.6)
	collision_tween.interpolate_property(self, "modulate", Color.white * 5, Color.white, 0.3)
	collision_tween.start()
