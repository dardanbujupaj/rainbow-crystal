extends Node

var frames = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in range(24):
		var image = Image.new()
		image.load("res://animated_icon/logo%d.png" % (i + 1))
		frames.append(image)
	
	frames.append(frames.pop_front())
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 15
	timer.connect("timeout", self, "animate_icon")
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_icon() -> void:
	for frame in frames:
		yield(get_tree().create_timer(0.05), "timeout")
		OS.set_icon(frame)
