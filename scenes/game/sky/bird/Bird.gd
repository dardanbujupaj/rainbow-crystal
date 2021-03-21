extends Node2D



var health = 10 setget _set_health
var velocity = Vector2()

onready var damage_tween = $DamageTween
onready var health_bar = $CanvasLayer/HealthBar

onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree["parameters/playback"]


onready var orb = $body/feet/Orb


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OrbPosition.position = position
	$OrbPosition.set_as_toplevel(true)


func _process(delta: float) -> void:
	position += velocity * delta

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
		
		
func activate():
	$Timer.start(5)
	health_bar.max_health = health
	health_bar.health = health
	health_bar.show()
	
	MusicEngine.play_song("Showdown")


func defeat():
	release_orb()
	velocity.y = 100
	

func release_orb() -> void:
	orb.collectible = true
	orb.scale = Vector2(1, 1)
	orb.attach_to_node($OrbPosition)

func _set_health(new_health: float):
	health_bar.health = new_health
	health = new_health


func _on_ActivationArea_body_entered(body: Node) -> void:
	print("%s entered" % str(body))
	activate()


func _on_Timer_timeout() -> void:
	state_machine.travel("pick")
