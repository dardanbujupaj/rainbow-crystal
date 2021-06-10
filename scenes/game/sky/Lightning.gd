extends Area2D


class Segment:
	var from: Vector2
	var to: Vector2
	var intensity: float
	
	static func create(from: Vector2, to: Vector2, intensity: float):
		var segment = Segment.new()
		segment.from = from
		segment.to = to
		segment.intensity = intensity
		return segment
		


onready var tween = $Tween
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	timer.wait_time = rand_range(0, 4)
	timer.start()
	tween.interpolate_property(self, "lightning_intensity", 1.0, 0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.1)


var lightning_intensity = 1.0
var lightning_distance = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()


func _draw() -> void:
	for segment in segments:
		if lightning_intensity < 1.0:
			if lightning_distance > segment.from.length():
				var segment_intensity = lightning_intensity * segment.intensity
				draw_line(segment.from, segment.to, Color(1.0, 1.0, 1.0, segment_intensity), 1)
				draw_line(segment.from, segment.to, Color(1.0, 1.0, 1.0, pow(segment_intensity, 6) * 0.5), 5)
		elif segment.intensity == 1.0:
			draw_line(segment.from, segment.to, Color.black, 3)
	


var segments = []


func generate_lightning(to_position: Vector2, generations = 4) -> void:
	segments.clear()
	
	segments.append(Segment.create(Vector2(), to_local(to_position), 1.0))
	for i in range(generations):
		var new_segments = []
		for segment in segments:
			new_segments.append_array(split_segment(segment, 0.5 / pow(2, i)))
		
		segments = new_segments
	
	
	tween.interpolate_property(self, "lightning_intensity", 1.0, 0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN, 0.1)
	tween.interpolate_property(self, "lightning_distance", 0.0, to_local(to_position).length() * 1.2, rand_range(0.1, 0.15), Tween.TRANS_LINEAR, Tween.EASE_IN, 0.1)
	tween.start()
	timer.wait_time = rand_range(1, 2)
	timer.start()
	
	update()


func split_segment(segment: Segment, offset_amount: float = 1.0) -> Array:
	var length = segment.from.distance_to(segment.to)
	var split_point = (segment.from + segment.to) / 2 # find center
	split_point += Vector2(rand_range(-length * offset_amount, length * offset_amount), rand_range(-length * offset_amount, length * offset_amount)) # add random offset
	
	var new_segments = []
	
	new_segments.append(Segment.create(segment.from, split_point, segment.intensity))
	new_segments.append(Segment.create(split_point, segment.to, segment.intensity))
	
	if (randf() < 0.9):
		var branch_point = split_point + (split_point - segment.from) * rand_range(0.6, 0.8)
		var branch_distance = split_point.distance_to(branch_point)
		branch_point += Vector2(rand_range(-branch_distance * offset_amount, branch_distance * offset_amount), rand_range(-branch_distance * offset_amount, branch_distance * offset_amount))
		new_segments.append(Segment.create(split_point, branch_point, segment.intensity * rand_range(0.4, 0.6)))
		
	return new_segments



func _on_Timer_timeout() -> void:
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		generate_lightning(bodies[0].global_position)
