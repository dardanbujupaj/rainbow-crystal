extends KinematicBody2D


var direction = sign(rand_range(-1, 1))
const SPEED = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_direction()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var collider = $RayCast2D.get_collider()
	
	if collider != null:
		direction *= -1
		update_direction()
		
		
		if collider is Character:
			collider.hit(0.3, Vector2(direction, 0))
			$RayCast2D.collide_with_bodies = false
			$AttackCooldown.start(1)
		
		
	move_and_slide(Vector2(direction * SPEED, 200), Vector2.UP)


func update_direction():
	$AnimatedSprite.scale.x = direction
	$RayCast2D.cast_to = Vector2(direction * 15, 0)


func hit(damage, impact):
	pass


func _on_AttackCooldown_timeout() -> void:
	$RayCast2D.collide_with_bodies = true
