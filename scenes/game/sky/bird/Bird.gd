extends Node2D



var health = 10 setget _set_health

onready var damage_tween = $DamageTween
onready var health_bar = $CanvasLayer/HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called by source, when character gets hit
# decrease health and show impact
func hit(damage: float, direction: Vector2):
	self.health -= damage
	print("new health" + str(health))
	
	SoundEngine.play_sound("CharacterHit")

	damage_tween.stop_all()
	damage_tween.interpolate_property(self, "modulate", modulate, Color.white * 5, 0.3)
	damage_tween.interpolate_property(self, "modulate", Color.white * 5, Color.white, 0.3)
	damage_tween.start()
	
	if health <= 0:
		defeat()
		

func defeat():
	pass


func _set_health(new_health: float):
	health_bar.health = new_health
	health = new_health
