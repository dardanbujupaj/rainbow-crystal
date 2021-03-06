extends KinematicBody2D
class_name Character


const ACCELERATION = 800
const DECELERATION = 1500
const MAX_SPEED = 200
const JUMP_SPEED = 320
const GRAVITY = 200
const JUMP_ACTIVE_MODIFIER = 2
const JUMP_PASSIVE_MODIFIER = 4
const FALL_MODIFIER = 6

const KNOCKBACK_INTENSITY = 150

# applied knockback when character gets hit
var knockback: Vector2

#current velocity
var velocity: Vector2

# disable jumping/walking for cutscenes
var moving_disabled = false

# store last collision to only call impact() on first collision with an object
var last_collider = null


onready var coyote_timer = $CoyoteTimer
onready var jump_memory_timer = $JumpMemoryTimer

onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree["parameters/playback"]

onready var damage_tween = $DamageColorTween


# Called when the node enters the scene tree for the first time.
# TODO: only 30 minutes left, so forgive me this anty-DRY mess...
func _ready():
	if SaveGame.red_orb_collected:
		var orb = preload("res://scenes/game/orb/Orb.tscn").instance()
		orb.color = Orb.OrbColor.RED
		orb.attach_to_character(self)
	if SaveGame.green_orb_collected:
		var orb = preload("res://scenes/game/orb/Orb.tscn").instance()
		orb.color = Orb.OrbColor.GREEN
		orb.attach_to_character(self)
	if SaveGame.blue_orb_collected:
		var orb = preload("res://scenes/game/orb/Orb.tscn").instance()
		orb.color = Orb.OrbColor.BLUE
		orb.attach_to_character(self)



# called everey physics frame
func _physics_process(delta):
	
	# apply conditions to animation state machine
	animation_tree["parameters/conditions/running"] = abs(velocity.x) > 1
	animation_tree["parameters/conditions/not_running"] = abs(velocity.x) < 1
	animation_tree["parameters/conditions/falling"] = velocity.y > 0
	animation_tree["parameters/conditions/on_floor"] = is_on_floor()
	
	
	var input_direction = Input.get_action_strength("g_right") - Input.get_action_strength("g_left")
	var shooting = state_machine.get_current_node() == "shoot"
	# handle horizontal movement
	if abs(input_direction) > 0.1 and not shooting and not moving_disabled:
		var uniform_direction = sign(input_direction)
		if $Sprite.scale.x == -uniform_direction:
			$Sprite.scale.x = uniform_direction
			$CollisionShape2D.scale.x = uniform_direction
			
		# Fast turn when changing run direction
		if sign(velocity.x) != sign(input_direction):
			velocity.x += input_direction * DECELERATION * delta
		else:
			velocity.x += input_direction * ACCELERATION * delta
		
		
		# Limit speed
		var speed_limit = MAX_SPEED * 2 if has_green_orb() else MAX_SPEED
		velocity.x = clamp(velocity.x, -speed_limit, speed_limit)
		
		#$character_body.play("walk")
	else:
		# stop when near 0 speed
		if abs(velocity.x) < (DECELERATION * delta):
			velocity.x = 0
			
			#$character_body.play("default")
		else:
			velocity.x -= velocity.x / abs(velocity.x) * DECELERATION * delta
	
	
	
	# if character is on floor
	if is_on_floor():
		# check if jump is press of queued
		if Input.is_action_just_pressed("g_jump") or jump_memory_timer.time_left > 0:
			jump()
		else:
			# reset jump, vertical velocity an coyote time
			coyote_timer.start()
			
			apply_gravity(delta)
	else:
		if Input.is_action_just_pressed("g_jump"):
			# coyote jump
			if coyote_timer.time_left > 0:
				jump()
			else:
				# activate jump memory timer
				jump_memory_timer.start()
				apply_gravity(delta)
		else:
			apply_gravity(delta)
	
	
	# add impact to objects which react on the player
	var collision = move_and_collide(velocity * delta, false, true, true)
	
	if collision != null and collision.collider != last_collider:
		if collision.collider.has_method("impact"):
			collision.collider.impact(velocity, collision.position)
	
	last_collider = collision.collider if collision else null
	
	
	if knockback.length() > 0.1:
		move_and_slide(knockback, Vector2.UP)
		knockback *= 0.9
		
	# velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	velocity = move_and_slide(velocity, Vector2.UP)
	


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("g_attack"):
		shoot()
	


# Helper functions to check if character has an orb
func has_red_orb():
	return has_node("RedOrb")

func has_green_orb():
	return has_node("GreenOrb")

func has_blue_orb():
	return has_node("BlueOrb")


# Called by source, when character gets hit
# decrease health and show impact
func hit(damage: float, direction: Vector2):
	knockback += direction * pow(damage, 2) * KNOCKBACK_INTENSITY
	$CameraCenter/Camera2D.add_trauma(damage / 2) # screenshake equal to dmg is a bit too much
	
	SoundEngine.play_sound("CharacterHit")
	
	damage_tween.stop_all()
	damage_tween.interpolate_property(self, "modulate", modulate, Color.white * 5, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	damage_tween.interpolate_property(self, "modulate", Color.white * 5, Color.white, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.3)
	damage_tween.start()
	

func shoot():
	if state_machine.get_current_node() != "shoot" and !moving_disabled:
		state_machine.travel("shoot")
		yield(get_tree().create_timer(0.5), "timeout")
		
		var instance = preload("res://scenes/game/character/SlingshotProjectile.tscn").instance()
		instance.position = position + Vector2(0, -7)
		instance.velocity = Vector2($Sprite.scale.x * 300, -25)
		add_child(instance)
	

# apply gravity depending on jump state
func apply_gravity(delta):
	var modifier
	
	if velocity.y > 0:
		modifier = FALL_MODIFIER
	elif Input.is_action_pressed("g_jump"):
		modifier = JUMP_ACTIVE_MODIFIER
	else:
		modifier = JUMP_PASSIVE_MODIFIER
		
	velocity.y += GRAVITY * modifier * delta


func jump():
	if moving_disabled:
		return
	
	state_machine.travel("jump_up")
	velocity.y = -JUMP_SPEED
	
	coyote_timer.stop()
	jump_memory_timer.stop()
