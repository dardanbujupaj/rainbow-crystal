tool
extends Area2D

enum Area {
	VILLAGE
	FOREST
	MOUNTAIN
	SKY
}

var portals = {
	Area.VILLAGE: {
		"image": preload("res://scenes/game/village_portal.png"),
		"scene": "res://scenes/game/village/Village.tscn",
		"color": Color("66ffe3")
	},
	Area.FOREST: {
		"image": preload("res://scenes/game/forest_portal.png"),
		"scene": "res://scenes/game/forest/Forest.tscn",
		"color": Color("3ca370")
	},
	Area.MOUNTAIN: {
		"image": preload("res://scenes/game/mountain_portal.png"),
		"scene": "res://scenes/game/mountain/Mountain.tscn",
		"color": Color("eb564b")
	},
	Area.SKY: {
		"image": preload("res://scenes/game/sky_portal.png"),
		"scene": "res://scenes/game/sky/Sky.tscn",
		"color": Color("4b5bab")
	},
}


export(Area) var destination setget _set_destination


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_destination(destination)


func _set_destination(new_destination):
	if has_node("image"):
		$image.texture = portals[new_destination]["image"]
		$CPUParticles2D.color = portals[new_destination]["color"]
	destination = new_destination


func _on_Portal_body_entered(body: Node) -> void:
	if body is Character:
		var area = ResourceLoader.load(portals[destination]["scene"])
		get_tree().call_group("game", "load_area", area)
