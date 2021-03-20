tool
extends Area2D
class_name Orb

signal collected


enum OrbColor { RED, GREEN, BLUE }

export(OrbColor) var color setget _set_color
export var draw_orb = true

export(bool) var collectible = false setget _set_collectible

onready var tween = $Tween

func _ready() -> void:
	_set_color(color)
	_set_collectible(collectible)
	tween_to_offset()

var offset: Vector2

func _process(delta: float) -> void:
	if is_set_as_toplevel():
		var target = get_parent().global_position + offset
		position = position.linear_interpolate(target, 0.05)

	

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
	if character.has_node("Orb"):
		character.get_node("Orb").free()
	
	name = "Orb"
	
	SaveGame.orb_equipped = color
	
	emit_signal("collected")
	
	attach_to_node(character)


func attach_to_node(node: Node) -> void:
	self.collectible = false
	
	
	if get_parent():
		position = global_position
		get_parent().remove_child(self)
	else:
		position = node.global_position
		
	node.add_child(self)
	set_as_toplevel(true)
	tween_to_offset()


func tween_to_offset() -> void:
	var target_offset = Vector2(rand_range(-1, 1), rand_range(-1, 1)) * 30
	tween.stop_all()
	tween.interpolate_property(self, "offset", offset, target_offset, 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	tween_to_offset()
