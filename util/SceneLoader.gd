extends Node

# Define scenes which have to be loaded at game start
# this will reduce stuttering when changing to big scenes
var preloaded_scenes = {
}


var current_scene = null

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	

func goto_scene(path: String, properties: Dictionary = {}) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, properties)


func _deferred_goto_scene(path: String, properties: Dictionary) -> void:
	# It is now safe to remove the current scene
	# Load the new scene.
	
	var s: Resource
	
	if preloaded_scenes.has(path):
		s = preloaded_scenes[path]
	else:
		s = ResourceLoader.load(path)
		preloaded_scenes[path] = s
	
	var old_scene = current_scene
	
	# Instance the new scene.
	current_scene = s.instance()
	
	for property in properties.keys():
		current_scene.set(property, properties[property])

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the 
	# SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	old_scene.free()
