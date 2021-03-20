extends Node2D


func _on_Apple_body_entered(body: Node) -> void:
	get_parent().apples += 1
	queue_free()
