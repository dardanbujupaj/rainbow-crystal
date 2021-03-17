extends Node2D



onready var shader: ShaderMaterial = $CanvasLayer/TextureRect.material


# enable or disable a color
func _set_color_enabled(enabled: bool, color: String) -> void:
	shader.set_shader_param("%s_enabled" % color, enabled)


# load an area in the game
# This is usually called by the Portal class
func load_area(scene: PackedScene) -> void:
	print("load area %s" % scene)
	var instance = scene.instance()
	instance.name = "Scene"
	$Scene.queue_free()
	
	call_deferred("add_child", instance)
