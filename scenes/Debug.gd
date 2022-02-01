extends VBoxContainer


onready var fps := $FPS
onready var resolution := $Resolution


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	fps.text = "%d FPS" % Performance.get_monitor(Performance.TIME_FPS)
	
	resolution.text = "%dx%d" % [OS.window_size.x, OS.window_size.y]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
