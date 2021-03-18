tool
extends MarginContainer


export var max_health = 100 setget _set_max_health
export var health = 100 setget _set_health
export var color = Color("3ca370") setget _set_color


onready var health_bar = $VBoxContainer/CenterContainer/HealthBar
onready var health_bar_backdrop = $VBoxContainer/CenterContainer/HealthBarBackdrop
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_health(health)
	_set_max_health(max_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _set_max_health(new_max_health: float) -> void:
	if health_bar != null:
		health_bar.max_value = new_max_health
		health_bar_backdrop.max_value = new_max_health
	max_health = new_max_health


func _set_health(new_health: float) -> void:
	if health_bar != null:
		health_bar.value = new_health
		tween.stop_all()
		tween.interpolate_property(health_bar_backdrop, "value", health_bar_backdrop.value, new_health, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
	health = new_health
	

func _set_color(new_color: Color) -> void:
	if health_bar != null:
		health_bar.tint_progress = new_color
	color = new_color
