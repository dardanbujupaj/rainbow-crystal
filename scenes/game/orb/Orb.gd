tool
extends Area2D
class_name Orb

signal collected


enum OrbColor { RED, GREEN, BLUE }

export(OrbColor) var color: int setget _set_color
export var draw_orb := true

export(bool) var collectible := false setget _set_collectible

onready var tween := $Tween


var velocity: Vector2

var offset_noise = OpenSimplexNoise.new()

func _ready() -> void:
	_set_color(color)
	_set_collectible(collectible)
	
	randomize()
	offset_noise.period = 5000
	offset_noise.octaves = 2
	offset_noise.seed = randi()
	
	
	


func _process(delta: float) -> void:
	if is_set_as_toplevel():
		var offset := Vector2(offset_noise.get_noise_1d(OS.get_ticks_msec()), offset_noise.get_noise_1d(-OS.get_ticks_msec())) * 100
		var distance = get_parent().global_position - global_position + offset
		velocity = velocity.linear_interpolate(distance * 2, 10 * delta)
		global_position += velocity * delta
	else:
		velocity = Vector2()


func _set_collectible(new_collectible: bool) -> void:
	set_collision_mask_bit(0, new_collectible)
	collectible = new_collectible


func _set_color(new_color):
	color = new_color
	if $Sprite != null:
		match color:
			OrbColor.RED:
				$Sprite.texture = preload("res://scenes/game/orb/orb/orb_red.png")
				$CPUParticles2D.color = Color("eb564b")
			OrbColor.GREEN:
				$Sprite.texture = preload("res://scenes/game/orb/orb/orb_green.png")
				$CPUParticles2D.color = Color("8fde5d")
			OrbColor.BLUE:
				$Sprite.texture = preload("res://scenes/game/orb/orb/orb_blue.png")
				$CPUParticles2D.color = Color("4b5bab")


func _on_Orb_body_entered(body: Node) -> void:
	var character = body
	call_deferred("attach_to_character", body)
	

func attach_to_character(character: Node) -> void:
	
	match color:
		OrbColor.RED:
			SaveGame.red_orb_collected = true
			if is_inside_tree():
				get_tree().call_group("game", "_set_color_enabled", true, "red")
				SoundEngine.play_sound("OrbCollected")
			name = "RedOrb"
		OrbColor.GREEN:
			SaveGame.green_orb_collected = true
			if is_inside_tree():
				get_tree().call_group("game", "_set_color_enabled", true, "green")
				SoundEngine.play_sound("OrbCollected")
			name = "GreenOrb"
		OrbColor.BLUE:
			SaveGame.blue_orb_collected = true
			if is_inside_tree():
				get_tree().call_group("game", "_set_color_enabled", true, "blue")
				SoundEngine.play_sound("OrbCollected")
			name = "BlueOrb"
	
	if character.has_node(name):
		character.get_node(name).free()
		
	
	SaveGame.orb_equipped = color
	
	emit_signal("collected")
	
	attach_to_node(character)
	
	
	if (SaveGame.red_orb_collected and
		SaveGame.green_orb_collected and
		SaveGame.blue_orb_collected):
		if get_tree():
			get_tree().call_group("game", "game_completed")


func attach_to_node(node: Node) -> void:
	self.collectible = false
	
	
	if get_parent():
		position = global_position
		get_parent().remove_child(self)
	else:
		position = node.global_position
		
	node.add_child(self)
	set_as_toplevel(true)
