extends Node2D



onready var shader: ShaderMaterial = material

onready var current_scene


func _ready() -> void:
	if SaveGame.tutorial_completed:
		load_area(preload("res://scenes/game/village/Village.tscn"))
	else:
		load_area(preload("res://scenes/game/tutorial/Tutorial.tscn"))


# enable or disable a color
func _set_color_enabled(enabled: bool, color: String) -> void:
	shader.set_shader_param("%s_enabled" % color, enabled)


# load an area in the game
# This is usually called by the Portal class
func load_area(area: PackedScene) -> void:
	print("load area %s" % area)
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = area.instance()
	
	call_deferred("add_child", current_scene)
	
	$BackgroundColor/ColorRect.color = current_scene.background_color
