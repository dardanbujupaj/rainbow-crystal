tool
extends Node2D


enum Direction {
	LEFT
	RIGHT
	UP
	DOWN
}


export(String) var text: String setget _set_text
export(Direction) var direction: int setget _set_direction


onready var label = $Node2D/CenterContainer/MarginContainer/CenterContainer/MarginContainer/Label
onready var ninepatch_right = $Node2D/CenterContainer/MarginContainer/NinePatchRectRight
onready var ninepatch_left = $Node2D/CenterContainer/MarginContainer/NinePatchRectLeft


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_text(text)
	_set_direction(direction)

func _set_text(new_text: String) -> void:
	if label != null:
		label.text = tr(new_text)	
	text = new_text
	
	
func _set_direction(new_direction: int) -> void:
	if ninepatch_left:
		match new_direction:
			Direction.LEFT:
				ninepatch_left.show()
				ninepatch_right.hide()
			Direction.RIGHT:
				ninepatch_left.hide()
				ninepatch_right.show()
	
	direction = new_direction
