extends Area2D


export(PackedScene) var destination_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_Portal_body_entered(body: Node) -> void:
	if body is Character:
		get_tree().call_group("game", "load_area", destination_scene)
