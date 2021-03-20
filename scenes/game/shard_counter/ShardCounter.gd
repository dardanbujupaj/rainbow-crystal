extends PanelContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MarginContainer/HBoxContainer/Label.text = str(SaveGame.collected_shards)
