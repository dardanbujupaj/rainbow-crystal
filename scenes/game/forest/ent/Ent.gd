extends Node2D


onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree["parameters/playback"]
onready var damage_tween = $DamageTween
onready var health_bar = $CanvasLayer/HealthBar

const MAX_HEALTH = 3

var health = MAX_HEALTH setget _set_health


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(2), "timeout")
	#activate()


func activate():
	state_machine.travel("activate")
	$Orb/Hitbox.monitorable = true
	$Timer.start(5)
	health = MAX_HEALTH
	health_bar.max_health = MAX_HEALTH
	health_bar.health = MAX_HEALTH
	health_bar.show()
	
	MusicEngine.play_song("Showdown")


func creak() -> void:
	SoundEngine.play_sound("EntCreak")


func impact(amount: float) -> void:
	SoundEngine.play_sound("EntImpact")
	get_tree().call_group("cameras", "add_trauma", amount)


func start_combat():
	pass


func spawn_acorn(position: Vector2 = Vector2()):
	var instance = preload("res://scenes/game/forest/ent/acorn/Acorn.tscn").instance()
	instance.position = position
	# instance.set_as_toplevel(true)
	add_child(instance)
	

func spawn_acorn_salve():
	for i in range(-5, 5):
		yield(get_tree().create_timer(0.5), "timeout")
		spawn_acorn(Vector2(50 * i, -200))
		

func defeat():
	$Timer.stop()
	$Orb/Hitbox.queue_free()
	
	health_bar.hide()
	state_machine.travel("defeat")
	MusicEngine.play_song("Runaway")

func release_orb() -> void:
	$Orb.collectible = true
	print($Orb.position)
	print($Orb.global_position)
	$Orb.position = $Orb.global_position
	$Orb.set_as_toplevel(true)
	print($Orb.position)
	


func _on_StompTimer_timeout() -> void:
	state_machine.travel("stomp")
	spawn_acorn_salve()


func _on_StompArea_body_entered(body: Node) -> void:
	body.hit(1, Vector2(-5, -5))
	$StompArea.visible = false
	$StompArea.collision_mask = 0


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


func _set_health(new_health: float):
	health_bar.health = new_health
	health = new_health


func _on_Orb_collected() -> void:
	$CanvasLayer2/Dialog.queue_step({
		"text_key": "DIALOG_FOREST_ORB"
	})
