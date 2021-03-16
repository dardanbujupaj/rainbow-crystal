extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

onready var shader: ShaderMaterial = $CanvasLayer/HSplitContainer/TextureRect.material

func _set_color_enabled(enabled: bool, color: String) -> void:
	shader.set_shader_param("%s_enabled" % color, enabled)
	

func load_area(scene: PackedScene) -> void:
	print("load area %s" % scene)
	var instance = scene.instance()
	instance.name = "Scene"
	$Scene.queue_free()
	
	call_deferred("add_child", instance)
