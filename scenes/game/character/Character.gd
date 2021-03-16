extends KinematicBody2D
class_name Character


const ACCELERATION = 800
const DECELERATION = 1000
const MAX_SPEED = 150
const JUMP_SPEED = 200
const GRAVITY = 200
const JUMP_MODIFIER = 1
const FALL_MODIFIER = 6

const KNOCKBACK_INTENSITY = 20

var knockback: Vector2
var velocity: Vector2

onready var coyote_timer = $CoyoteTimer
onready var jump_memory_timer = $JumpMemoryTimer

onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree["parameters/playback"]


var jumped


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	animation_tree["parameters/conditions/running"] = abs(velocity.x) > 1
	animation_tree["parameters/conditions/not_running"] = abs(velocity.x) < 1
	
	
	# handle horizontal movement
	if Input.is_action_pressed("g_left") or Input.is_action_pressed("g_right"):
		var input_direction = Input.get_action_strength("g_right") - Input.get_action_strength("g_left")
		if $Sprite.scale.x == -sign(input_direction):
			$Sprite.scale.x = sign(input_direction)
		# Fast turn when changing run direction
		if sign(velocity.x) != sign(input_direction):
			velocity.x += input_direction * DECELERATION * delta
		else:
			velocity.x += input_direction * ACCELERATION * delta
		
		# Limit speed
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
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
			jumped = false
			velocity.y = 0
	else:
		if Input.is_action_just_pressed("g_jump"):
			if coyote_timer.time_left > 0:
				jump()
			else:
				# activate jump memory timer
				jump_memory_timer.start()
				apply_gravity(delta)
		else:
			apply_gravity(delta)
			

	#$Label.text = str(velocity)
	velocity = move_and_slide(velocity + knockback, Vector2(0, -1))
	
	knockback *= 0.9
	
	



func hit(damage: float, direction: Vector2):
	knockback += direction * damage * KNOCKBACK_INTENSITY
	$CameraCenter/Camera2D.add_trauma(damage)
	

func apply_gravity(delta):
	var modifier = FALL_MODIFIER if velocity.y > 0 else JUMP_MODIFIER
	velocity.y += GRAVITY * modifier * delta

func jump():
	velocity.y = -JUMP_SPEED
	jumped = true
	coyote_timer.stop()
	jump_memory_timer.stop()
