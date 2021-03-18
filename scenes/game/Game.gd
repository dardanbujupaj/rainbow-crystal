extends Node2D



onready var shader: ShaderMaterial = material

onready var current_scene = $Scene


# enable or disable a color
func _set_color_enabled(enabled: bool, color: String) -> void:
	shader.set_shader_param("%s_enabled" % color, enabled)


# load an area in the game
# This is usually called by the Portal class
func load_area(area: PackedScene, background_color: Color = Color.black) -> void:
	print("load area %s" % area)
	current_scene.queue_free()
	
	current_scene = area.instance()
	
	call_deferred("add_child", current_scene)
	
	$BackgroundColor/ColorRect.color = background_color
