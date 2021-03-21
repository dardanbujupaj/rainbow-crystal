extends Node2D



onready var shader: ShaderMaterial = material

onready var current_scene


func _ready() -> void:
	
	if SaveGame.orbs_disappeared:
		if not SaveGame.red_orb_collected:
			_set_color_enabled(false, "red")
		if not SaveGame.green_orb_collected:
			_set_color_enabled(false, "green")
		if not SaveGame.blue_orb_collected:
			_set_color_enabled(false, "blue")
	
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
	($BackgroundColor/TextureRect.texture as GradientTexture).gradient.colors[0] = current_scene.background_color


func game_completed():
	if not SaveGame.game_completed:
		$CanvasLayer/Popup.popup_centered()
		SaveGame.game_completed = true
	


func _on_Credits_pressed() -> void:
	print("load credits")
	SceneLoader.goto_scene("res://scenes/credits/Credits.tscn")


func _on_Continue_pressed() -> void:
	$CanvasLayer/Popup.hide()


func _on_Complete_pressed() -> void:
	game_completed()
	$CanvasLayer/Complete.hide()


func _on_Menu_pressed() -> void:
	$CanvasLayer/AcceptDialog.popup_centered()


func _on_AcceptDialog_confirmed() -> void:
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
