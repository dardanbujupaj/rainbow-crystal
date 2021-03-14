tool
extends Node2D


export var color: Color setget _set_color


# Called when the node enters the scene tree for the first time.
func _draw() -> void:
	var circle_color = color
	circle_color.a = 0.5
	draw_circle(Vector2(), 3, circle_color)


func _set_color(new_color: Color):
	color = new_color
	$CPUParticles2D.color = new_color
