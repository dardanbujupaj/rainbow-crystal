tool
extends Node2D


enum OrbColor { RED, GREEN, BLUE }

export(OrbColor) var color setget _set_color
export var draw_orb = true


func _ready() -> void:
	_set_color(color)


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
